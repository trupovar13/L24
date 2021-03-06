require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'Pony'
require 'haml'


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
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

	# хеш
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

get '/contacts' do
	erb :contacts

end


post '/contacts' do
	@username = params[:username]
	@usermail = params[:usermail]
	@feedback = params[:feedback]

	hh = { 	:username => 'Введите имя',
			:usermail => 'Введите адрес почтового ящика',
			:feedback => 'Введите текст' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :contacts
	end

	Pony.mail(
   :username => params[:username],
  :usermail => params[:usermail],
  :feedback => params[:feedback],
  :to => 'trupovar13@gmail.com',
  :subject => params[:username] + " has contacted you",
  :feedback => params[:feedback],
  :port => '587',
  :via => :smtp,
  :via_options => { 
    :address              => 'smtp.gmail.com', 
    :port                 => '587', 
    :enable_starttls_auto => true, 
    :user_name            => 'trupovar13@gmail.com', 
    :password             => '', 
    :authentication       => :plain, 
    :domain               => 'localhost.localdomain'
  })

	@title = 'Thank you!'
	@message = "Dear #{@username}, thank you for your feedback"	

	f = File.open './public/feedback.txt', 'a'
	f.write "User: #{@username}, Usermail: #{@usermail}, Feedback: #{@feedback}"
	f.close

	erb :message

end
