require "time"

module Logger
    LOG_FILE = 'app.log'

    def log(message, level: :info)
        timestamp = Time.now.iso8601
        File.open(LOG_FILE, 'a') do |file|
            file.puts "#{timestamp} -- #{level} -- #{message}"
        end
    end 
    
    # Using metaprogramming to define log methods dynamically
    %i[info warning error].each do |level|
        define_method("log_#{level}") do |message|
            log(message, level: level)
        end
    end
end
