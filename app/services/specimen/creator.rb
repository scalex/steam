class Specimen::Creator
  def initialize specimen
    @specimen = specimen
  end

  def call params
    @specimen[:nick] = params[:nickname]
    Specimen::Updater.new(specimen).call params
  end
end
