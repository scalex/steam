class Specimen < Sequel::Model
  set_primary_key :nick
  plugin :serialization, :json, :links
  plugin :serialization, :json, :gimmicks
end
