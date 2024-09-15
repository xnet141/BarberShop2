#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do 
	db = SQLite3::Database.new 'barbershop.db'
	db.execute 'CREATE TABLE if not exists 
		"Users" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			 "username" TEXT, 
			 "phone" TEXT, 
			 "datestamp" TEXT, 
			 "barber" TEXT, 
			 "color" TEXT
		)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something wrong!'
	erb :about 
end

get '/contacts' do
	erb :contacts 
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]
		
		
	db = get_db
	db.execute 'insert into 
	Users 
	(
		username, 
		phone, 
		datestamp, 
		barber, 
		color
	)
	values(?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]



	hh = {
		'Имя пользователя' => @username, 
		:phone => @phone, 
		:datetime => @datetime, 
		:barber => @barber, 
		:color => @color
	}

	err = []
	
	hh.keys.each do |key|
		if  hh[key] == '' || hh[key] == '#7bd148'
			err << key
		end
	end

	if err.length == 0
		erb "User: #{@username}, Phone: #{@phone}, barber: #{@barber}, Date, time: #{@datetime}, Color: #{@color} \n"
	else
		@error = "Введите:  #{err.join(', ')}"
		erb :visit
	end

end


post '/contacts' do
	@email = params[:email]
	@text = params[:text]
	
	f = File.open "public/contacts.txt", "a"
	f.write "Email: #{@email}, Text: #{@text},\n"
	f.close


	erb :contacts
end

get '/showusers' do
  "Hello World"
end

def get_db
	return SQLite3::Database.new 'barbershop.db'
end