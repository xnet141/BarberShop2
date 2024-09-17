#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

def is_barber_exists? db, name
	db.execute('select * from Barbers where barber=?', [name]).length > 0	
end

def seed_db db, barbers
	barbers.each do |barber_new|
		if !is_barber_exists? db, barber_new
			db.execute 'insert into Barbers (barber) values (?)', [barber_new]
		end
	end	
end

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

	db.execute 'CREATE TABLE if not exists
                "Barbers"
                (
                        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                         "barber" TEXT
                )'
	
	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']            	
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
	
	db = get_db
	
	db.results_as_hash = true
	@arr = db.execute 'select * from Users order by id desc'
	
	
	erb :showusers
end

