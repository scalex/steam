class Specimen::Updater
  def initialize specimen
    @specimen = specimen
  end

  def call params
    @specimen[:lastname] = params[:lastname] if params[:firstname]
    @specimen[:firstname] = params[:firstname] if params[:firstname]
    @specimen[:position] = params[:position] if params[:position]
    @specimen[:about] = params[:about] if params[:about]

    update_links params
    add_gimmick params
    @specimen.save
  end


  def update_links params
    @specimen.links ||= {}
    params.select{|k,v| k =~ /link-\d+/ }.each do |key, value|
      if value && value.length > 0
        @specimen.links[key] = value
      end
    end
  end

  def add_gimmick params
    if params[:gimmick] && params[:gimmick].length > 0
      @specimen.gimmicks ||= []
      @specimen.gimmicks << params[:gimmick]
    end
  end
end
