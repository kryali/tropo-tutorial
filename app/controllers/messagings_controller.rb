class MessagingsController < ApplicationController

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
      Tropo::Generator.say "you said: " + m.post_match
    else
      Tropo::Generator.say "Unsupported operation"
    end
  end

end
