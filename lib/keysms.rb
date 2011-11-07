# encoding: utf-8

module Keysms
  
require 'digest/md5'
require 'json'
require 'patron'

class KeySMS
  attr_accessor :options, :payload, :values, :result
  
  def initialize(url = "http://app.keysms.no", options = {})
    @options, @payload, @values = {}, {}, {}
    @options = @options.merge(options)
    @options[:url] = url
  end
  
  def authenticate(username, key)
    @options[:auth] = {}
    @options[:auth][:username] = username
    @options[:auth][:key] = key
  end
  
  def sms(message, receivers, options = {})
    @options = @options.merge(options)
    @options[:path] = "/messages"
    
    if (receivers.is_a? String)
      receivers = [receivers]
    end
    
    @payload[:message] = message
    @payload[:receivers] = receivers
    
    prepare_request
    prepare_session
    send
  end
  
  private
  
  def prepare_session
    @session = Patron::Session.new
    @session.base_url = @options.delete(:url)
  end
  
  def prepare_request
    @values[:username] = @options[:auth][:username]
    @values[:signature] = sign
    @values[:payload] = @payload.to_json
  end
  
  def sign
    Digest::MD5.hexdigest(@payload.to_json + @options[:auth][:key])
  end
  
  def send
    data = @values.collect do | key, value |
      "#{key}=#{value}"
    end
    
    response = @session.post(@options[:path], data.join("&"))
    handle_response(response.body)
    @response
  end
  
  def handle_response(response_text)
    @result = JSON.parse(response_text)
    p @result
    begin
      if (@result["ok"] == false)
        error_code = find_error_code(@result)
        if (error_code == "not_authed")
          raise NotAuthenticatedError.new(@result)
        elsif (error_code == "message_no_valid_receivers")
          raise NoValidReceiversError.new(@result)
        elsif (error_code == "message_internal_error")
          raise InternalError.new(@result)
        else
          raise SMSError.new(@result)
        end
      end
    rescue NoMethodError => e
      raise SMSError.new(@result)
    end
  end
  
  def find_error_code(structure)
    structure.each do | key, value |
      if (key == "code")
        return value
      elsif (key == "error")
        if (value.is_a? String)
          return value
        elsif (value.is_a? Hash)
          return find_error_code(value)
        end
      end
    end
  end
 
end

class SMSError < StandardError
  attr_accessor :error
  def initialize(error)
    @error = error["error"]
    super
  end
end

class NotAuthenticatedError < SMSError
  attr_accessor :messages
  
  def initialize(error)
    @messages = error["messages"]
    super(error)
  end
  
  def to_s
    @messages.join(", ")
  end
end

class NoValidReceiversError < SMSError
  attr_accessor :failed_receivers
  
  def initialize(error)
    @failed_receivers = error["error"]["receivers"]["data"]["failed"]
    super(error)
  end
  
  def to_s
    @failed_receivers.join(", ")
  end
end

class InternalError < SMSError; end
end
# test
keysms = Keysms::KeySMS.new()
keysms.authenticate("40604088", "f5a306219de3f50abc6d59d62aa6cfa") #5
retval = keysms.sms("Dette er en test", "40604088")
p retval