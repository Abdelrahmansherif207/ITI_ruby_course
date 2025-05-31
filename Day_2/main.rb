require_relative 'Bank'

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),  
  Transaction.new(out_side_bank_users[0], -100) 
]

bank = CBABank.new(users)

bank.process_transactions(transactions) do |status, transaction, reason = nil|
  user = transaction.user
  value = transaction.value
  
  if status == "success"
    puts "Call endpoint for success of User #{user.name} transaction with value #{value}"
  else
    puts "Call endpoint for failure of User #{user.name} transaction with value #{value} : #{reason}"
  end
end