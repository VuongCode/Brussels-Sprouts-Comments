require 'pg'
require 'faker'

TITLES = ["Roasted Brussels Sprouts",
  "Fresh Brussels Sprouts Soup",
  "Brussels Sprouts with Toasted Breadcrumbs, Parmesan, and Lemon",
  "Cheesy Maple Roasted Brussels Sprouts and Broccoli with Dried Cherries",
  "Hot Cheesy Roasted Brussels Sprout Dip",
  "Pomegranate Roasted Brussels Sprouts with Red Grapes and Farro",
  "Roasted Brussels Sprout and Red Potato Salad",
  "Smoky Buttered Brussels Sprouts",
  "Sweet and Spicy Roasted Brussels Sprouts",
  "Smoky Buttered Brussels Sprouts",
  "Brussels Sprouts and Egg Salad with Hazelnuts"]

#WRITE CODE TO SEED YOUR DATABASE AND TABLES HERE
COMMENTS = Faker::Lorem.paragraphs(rand(30..50))

system "psql brussels_sprouts_recipes < schema.sql"

def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end

def list_recipes
  db_connection do |conn|
    TITLES.each do |recipe|
      conn.exec("INSERT INTO recipes (recipe_name) VALUES ($1)", [recipe])
    end
  end
end

def list_comments
  db_connection do |conn|
    COMMENTS.each do |recipe|
      conn.exec("INSERT INTO comments (comment, recipe_id) VALUES ($1, $2)", [recipe, rand(1..11)])
    end
  end
end

list_recipes
list_comments

# How many recipes are there in total?
def recipes
  db_connection do |conn|
    conn.exec("SELECT * FROM recipes").to_a
  end
end
puts "There are #{recipes.count} total recipes."

# How many comments are there in total?
def comments
  db_connection do |conn|
    conn.exec("SELECT * FROM comments").to_a
  end
end
puts "There are #{comments.count} total comments."

# How would you find out how many comments each of the recipes have?
def comments_per_recipe
  db_connection do |conn|
    conn.exec("SELECT recipe_id, COUNT(*) FROM comments GROUP BY recipe_id").to_a
  end
end
puts comments_per_recipe

# # * What is the name of the recipe that is associated with a specific comment?
def recipe_with_comments
  db_connection do |conn|
    conn.exec("SELECT recipes.id, comments.comment FROM recipes INNER JOIN comments ON comments.recipe_id=recipes.id").to_a
  end
end

puts recipe_with_comments

# Add a new recipe titled `Brussels Sprouts with Goat Cheese`. Add two comments to it.
# def add_recipe
#   db_connection do |conn|
#     conn.exec("INSERT INTO recipes (recipe_name) VALUES ($1)", ["Brussels Sprouts with Goat Cheese"])
#   end
# end
#
# add_recipe
# puts "There are #{recipes.count} total recipes."
# puts "There are #{comments.count} total comments."
