require_relative 'logger-module'

class User
  attr_accessor :name, :balance
  
  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  attr_reader :user, :value
  
  def initialize(user, value)
    @user = user
    @value = value
  end
end

class Bank
  def process_transactions(transactions, &callback)
    raise NotImplementedError, "Subclass must implement abstract method"
  end
end

class CBABank < Bank
  include Logger

  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &callback)
    transaction_descriptions = transactions.map { |t| "User #{t.user.name} transaction with value #{t.value}" }
    log_info("Processing Transactions #{transaction_descriptions.join(', ')}...")

    transactions.each do |transaction|
      user = transaction.user
      value = transaction.value

      begin
        unless @users.include?(user)
          raise "#{user.name} not exist in the bank!!"
        end

        if user.balance + value < 0
          raise "Not enough balance"
        end

        user.balance += value

        log_info("User #{user.name} transaction with value #{value} succeeded")

        if user.balance == 0
          log_warning("#{user.name} has 0 balance")
        end

        callback.call("success", transaction)
      rescue => e
        log_error("User #{user.name} transaction with value #{value} failed with message #{e.message}")
        callback.call("failure", transaction, e.message)
      end
    end
  end
end
