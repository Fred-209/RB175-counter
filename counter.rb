=begin
expand the program
Have a link you can click that increments a number, and another link that decrements
a number. 
=end

require 'socket'

def extract_path(str)
  return '/' if str[1] == '?'

  path = ''
  str.each_char do |char|
    break if char == '?'
    path << char
  end
  path
end

def extract_parameters(str)
  return {} if str.length == 1

  parameters = {}
  query_array = str[2..-1].split('&')
  
  query_array.each do |parameter|
    name, value = parameter.split('=')
    parameters[name] = value
  end
  parameters
end

def parse_request(request_line)
  http_method, path_and_params, http_version = request_line.split
  path = extract_path(path_and_params)
  params = extract_parameters(path_and_params)
  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)

loop do 
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path, params = parse_request(request_line)
    
  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts("<h1>Counter</h1>")

  number = params['number'].to_i
  
  client.puts "<p>The current number is #{number}.</p>"
  client.puts "<a href='?number=#{number + 1}'>Increment Number</a>"
  client.puts "<a href='?number=#{number - 1}'>Decrement Number</a>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end






