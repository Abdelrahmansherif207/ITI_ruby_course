require "json"

class Book 
    attr_accessor :title,:author,:isbn ,:count

    def initialize(title,author,isbn, count=1)
        @title=title
        @author=author
        @isbn=isbn
        @count=count
    end

end


class Inventory
    FILE_PATH='books.json'

    def initialize()
        @books=load_books
    end

    def load_books
        if File.exist?(FILE_PATH)
            file = File.read(FILE_PATH)
            data=JSON.parse(File.read(FILE_PATH))
            data.map do |hash_book|
                Book.new(hash_book['title'], hash_book['author'], hash_book['isbn'])
            end
        else
            []
        end
    end

    def add_book(book)
        if book.title.nil? || book.author.nil? || book.isbn.nil?
            puts "Book details cannot be nil."
            return
        end
        if book.title.empty? || book.author.empty? || book.isbn.empty?
            puts "Book details cannot be empty."
            return
        end

        existing_book = @books.find { |b| b.isbn == book.isbn }
        if existing_book
            existing_book.count += 1;
            existing_book.title = book.title
            existing_book.author = book.author
            # existing_book.isbn = book.isbn
            puts "Book with ISBN #{book.isbn} already exists. Incrementing count."
            save_books
            return
        else
            # book.count = 1
            puts "Adding book: Title: #{book.title}, Author: #{book.author}, ISBN: #{book.isbn}"
            @books << book
            save_books
        end
    end
    
    def save_books
        File.open(FILE_PATH, 'w') do |file|
            file.write(JSON.pretty_generate(@books.map { |book| { title: book.title, author: book.author, isbn: book.isbn , count:book.count} }))
        end
    end

    def list_books
        @books.each do |book|
            puts "Title: #{book.title}, Author: #{book.author}, ISBN: #{book.isbn}"
        end
    end

    def remove_book(isbn)
        if @books.none? { |book| book.isbn == isbn }
            puts "No book found with ISBN #{isbn}."
            return
        end
        if isbn.nil? || isbn.empty?
            puts "ISBN cannot be nil or empty."
            return
        end
        if book=@books.count { |book| book.isbn == isbn } > 1
            book.count -= 1
            puts "Decrementing count for book with ISBN #{isbn}. New count: #{book.count}"
            save_books
            return
        end
        puts "Removing book with ISBN #{isbn}..."
        @books.reject! { |book| book.isbn == isbn }
        save_books
    end

    def search_book(search_type, search_value)
        unless ["title", "author", "isbn"].include?(search_type)
            puts "Invalid search type. Please use 'title', 'author', or 'isbn'."
            return
        end

        book = @books.find { |b| b.send(search_type) == search_value }
        if book
            puts "Found book: Title: #{book.title}, Author: #{book.author}, ISBN: #{book.isbn}"
        else
            puts "No book found with #{search_type} #{search_value}."
        end
    end

    def sort_by_isbn
        @books.sort_by!{|book| book.isbn}
        save_books
        puts "Books sorted by ISBN."
    end
end

# user menu
def user_menu
    puts "Welcome to the Book Inventory System"
    puts "1. Add a book"
    puts "2. List all books"
    puts "3. Remove a book"
    puts "4. Search for a book"
    puts "5. Sort books by ISBN"
    puts "6. Exit"

    print "Please choose an option: "
    gets.chomp.to_i
end

while true
    choice = user_menu

    inventory = Inventory.new

    case choice
    when 1
        print "Enter book title: "
        title = gets.chomp
        print "Enter book author: "
        author = gets.chomp
        print "Enter book ISBN: "
        isbn = gets.chomp
        inventory.add_book(Book.new(title, author, isbn))
    when 2
        inventory.list_books
    when 3
        print "Enter ISBN of the book to remove: "
        isbn = gets.chomp
        inventory.remove_book(isbn)
    when 4
        print "Search by (title/author/isbn): "
        search_type = gets.chomp.downcase
        print "Enter search value: "
        search_value = gets.chomp
        inventory.search_book(search_type, search_value)
    when 5
        inventory.sort_by_isbn
    when 6
        puts "Exiting the system. Goodbye!"
        break
    else
        puts "Invalid choice. Please try again."
    end

    puts "\n"
end
