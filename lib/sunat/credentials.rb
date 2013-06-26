module SUNAT
  class Credentials < Struct.new(:ruc, :username, :password)
    def login
      ruc + username
    end
  end
end