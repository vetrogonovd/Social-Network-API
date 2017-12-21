class Api::V3::ParseController < BaseController

  include ParseDoc

  def parse_url
    url = params[:url]
    @preview = LinkParser.parse(url)
    if @preview == 'Bad URL, please check it'
      render :parse_url, status: :unprocessable_entity
    else
      render :parse_url, status: :ok
    end
  end

end
