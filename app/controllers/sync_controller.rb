require('HTTP')
require('json')
require('Date')
class SyncController < ApplicationController
  # POST /sync
  def create
    pageIndex = 1;
    response = HTTP.auth(Rails.application.secrets.api_key).get('https://jigsaw.thoughtworks.net/api/people', :params => {:page => pageIndex, :staffing_office => 'Chennai'})
    totalPages = response.headers["X-Total-Pages"].to_i
    responseBody = JSON.parse((response).to_s);
    while pageIndex <= totalPages do
      response = HTTP.auth(Rails.application.secrets.api_key).get('https://jigsaw.thoughtworks.net/api/people', :params => {:page => pageIndex, :staffing_office => 'Chennai'})
      responseBody += JSON.parse((response).to_s)
      pageIndex += 1
    end

    responseBody.each_with_index {|x, index|
      employeeId = x['employeeId']
      new_response = JSON.parse(HTTP.auth(Rails.application.secrets.api_key).get("https://jigsaw.thoughtworks.net/api/people/#{employeeId}/work_experiences").to_s);
      timeInCurrentAccount = 0
      lastAccountName = ''
      unless new_response.empty? then
        lastAccountName = new_response[0]['account']['name']
        new_response.map {|x|
          startsOn = Date.strptime(x['duration']['startsOn'], '%Y-%m-%d')
          endsOn = Date.strptime(x['duration']['endsOn'], '%Y-%m-%d')
          endsOn = Date.today if endsOn > Date.today
          (timeInCurrentAccount += (endsOn - startsOn).to_i) if x['account']['name'] == lastAccountName
        }
      end
      @people = People.new()
      @people.employeeId=x['employeeId']
      @people.preferredName=x['preferredName']
      @people.gender=x['gender']
      @people.role=x['role']['name']
      @people.grade=x['grade']['name']
      @people.picture=x['picture']['url']
      @people.totalExperience= x['totalExperience']
      @people.twExperience=x['twExperience']
      @people.homeOffice=x['homeOffice']['name']
      @people.assignable=x['assignable']
      @people.inBeach=lastAccountName
      @people.timeInCurrentAccount=timeInCurrentAccount;
      @people.save
      puts @person
    }
    render json: responseBody.to_json
  end
end
