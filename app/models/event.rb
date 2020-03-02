class Event < ActiveRecord::Base
  belongs_to :user
  
  #attr_accessor :isReadOnly, :calendarId

  #def initialize(calendarId: 0)
  #  @calendarId = calendarId
  #end

  #def isReadOnly=(var)
  #  @isReadOnly = var
  #end
  
  #def isReadOnly
  #  @isReadOnly
  #end

  #def calendarId=(var)
  #  @calendarId = var
  #end
  
  #def calendarId
  #  @calendarId
  #end
end
