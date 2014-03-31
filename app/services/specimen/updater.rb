class Specimen::Updater
  def initialize specimen
    @specimen = specimen
  end

  def call params
    @specimen[:lastname] = params[:lastname]
    @specimen[:firstname] = params[:firstname]
    @specimen.save
  end
end
