class MessagingsController < ApplicationController

    require 'tropo-webapi-ruby'
    require 'net/http'
	require 'uri'

	def send_text
#		json_session = request.env["rack.input"]
			
		#tropo_session = Tropo::Generator.parse(request.env)
#		numbers = ["+16097851404", "+12035640280", "+19084624278", "+16303625687", "+16097123995", "+16097851404"]
#		numbers = ["+17328298692", "+19726768582", "+6463513512", "+18478480509"]
#		numbers = ["17082755700"]
		numbers = ["16097851404"]
		numbers.each do |number|
			@number = number
			@message = "Courses+can+text+your+phone+now+bitch"
			@myToken = "1bfbc049ce83714697a6d23c43e584f10447935ec48b23414e6162b9cb808d84cec845ea4bac4ca2a24c818c"
			@API_URL='http://api.tropo.com/1.0/sessions?action=create&token=' + @myToken + '&numberToCall=' + @number+ '&msg=' + @message
			logger.debug "URI: #{@API_URL}"
			response = Net::HTTP.get URI.parse(@API_URL)
			logger.debug "response #{session}"
		end
		render :html => session
	end

	def receive
		if params['session']['userType'] == 'HUMAN'
			tropo_session = Tropo::Generator.say("Cut me some slack asshole, I haven't implemented responses yet")
			logger.debug "============Got a human response!============"
			@message = (params['session']['from']['id'] + ": "+ params['session']['initialText']).gsub(/\s/, "+")
			@number = "16097851404"
			@myToken = "1bfbc049ce83714697a6d23c43e584f10447935ec48b23414e6162b9cb808d84cec845ea4bac4ca2a24c818c"
			@API_URL='http://api.tropo.com/1.0/sessions?action=create&token=' + @myToken + '&numberToCall=' + @number+ '&msg=' + @message
			response = Net::HTTP.get URI.parse(@API_URL)
		else
			message = params['session']['parameters']['msg']
			number = params['session']['parameters']['numberToCall']
			logger.debug "Message #{message}"
			logger.debug "Number #{number}"
			tropo_session = Tropo::Generator.message({ :say => {:value => message}, :to => number, :channel => 'TEXT', :network => 'SMS'})
			logger.debug "Session: #{tropo_session}"
		end

		render :json => tropo_session
	end

  def index
    initial_text = params["session"]["initialText"]
      from = params["session"]["from"]
    network = from["network"]
    from_id = from["id"]
    if network == "SMS"
      render :json => parse(initial_text)
    else
      render :json => Tropo::Generator.say("Unsupporeted operation")
    end
  end

  def parse(input)
    input.strip!
    if m = input.match(/^(n|N)\s+/)
      Tropo::Generator.say "Test Message"
    end
  end

end
