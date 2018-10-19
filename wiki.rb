
require "sinatra"
require "uri"

def page_content(title)
	File.read("pages/#{title}.txt")
rescue Errno::ENOENT
	return "The page is not found." # if the page doesnt exist it returns null
end

def save_content(title, content)
	File.open("pages/#{title}.txt", "w") do |file|
		file.print(content)
	end
end
# save_content("Test", "\nHebele\n")

def delete_content(title)
	File.delete("pages/#{title}.txt")
end

get "/" do
	erb :welcome # as a symbol, it will render it as welcome.erb
	# to use diffent layout, "layout: :page.rb"
end

get "/test" do
	erb :test
end

get "/new" do
	erb :new
end

get "/:title" do
	@title = params[:title] # {"title"=>"Bora Tanrikulu"}
	@content = page_content(@title)

	erb :show
end

#
# get("/:title/:subtitle") do
#	params.inspect # {"title"=>"Bora Tanrikulu", "subtitle"=>"test"}
# end
#

get "/:title/edit" do
	@title = params[:title]
	@content = page_content(@title)

	erb :edit
end

#
# Post requests are for brand new resources that you haven't
# assinged a path to on the server.
#
post "/create" do
	@title = params[:title]
	@content = params[:content]

	save_content(@title, @content)
	redirect URI.escape ("/#{@title}")
end

#
# Put requests are for modifying an existing resource with
# a known URL.
#
put "/:title" do
	@title = params[:title]
	@content = params[:content]

	save_content(@title, @content)
	redirect URI.escape ("/#{@title}")
end

delete "/:title" do
	@title = params[:title]

	delete_content(@title)
	redirect ("/")
end
