# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require 'net/http'
require 'uri'
require 'json'

# An example output that does nothing.
class LogStash::Outputs::HangoutChat < LogStash::Outputs::Base
  
  config_name "hangoutchat"
  
  # the access token, cloud_id and conversation id of the stride room
  config :webhook, :validate => :string, :required => true

  # message variable contains the default message retreived inside logstash
  # Examples:-
  # for nxlog default message is in `Message` variable
  # for filebeat & log4j default message is in `message` variable
  config :message, :validate => :string, :default => "%{message}"

  # the host contains the IP, type is the type of log and severity denotes priority
  config :host, :validate => :string, :default => "%{host}"
  config :type, :validate => :string, :default => "%{type}"
  config :priority, :validate => :string, :default => "%{priority}"
  
  public
  def register
  end # def register

  public
  def receive(event)
    
    # initialize all variables
    url = event.sprintf(@webhook)
    message = event.sprintf(@message)
    host = event.sprintf(@host)
    type = event.sprintf(@type)
    priority = event.sprintf(@priority)

    post_message(url,host,type,priority,message)
    
  rescue Exception => e
    puts '**** ERROR ****'
    puts e.message
  end

  # sends the message to hangout-chat
  public
  def post_message(url,host,type,priority,message)
    
    # format of the log
    message = %Q|#{Time.now} : #{message}|
    message = %Q|#{host} : #{message}| if host
    message = %Q|#{type} : #{message}| if type
    message = %Q|#{priority} : #{message}| if priority

    # prep and send the http request 
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = "application/json"
    request.body = {text: message}.to_json
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

  end
  
end # class LogStash::Outputs::HangoutChat
