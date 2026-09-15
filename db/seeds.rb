books = [
  { title: "Dune", author: "Frank Herbert", price: "12.95", published_date: Date.new(1965, 8, 1) },
  { title: "Pride and Prejudice", author: "Jane Austen", price: "9.50", published_date: Date.new(1813, 1, 28) },
  { title: "The Hobbit", author: "J. R. R. Tolkien", price: "14.99", published_date: Date.new(1937, 9, 21) },
  { title: "Fahrenheit 451", author: "Ray Bradbury", price: "11.00", published_date: Date.new(1953, 10, 19) },
  { title: "Little Women", author: "Louisa May Alcott", price: "10.25", published_date: Date.new(1868, 9, 30) }
]

books.each do |attributes|
  Book.find_or_create_by!(title: attributes[:title]) do |book|
    book.assign_attributes(attributes)
  end
end

puts "Seed data ready: #{Book.count} books in #{Rails.env}."
