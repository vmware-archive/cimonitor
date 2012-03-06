# Originally rom http://jjinux.blogspot.com/2012/02/ruby-working-around-ssl-errors-on-os-x.html
# config/initializers/fix_ssl.rb
#
# Work around errors that look like:
#
#   SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (OpenSSL::SSL::SSLError)
# More information on the problem itself available at http://martinottenwaelter.fr/2010/12/ruby19-and-the-ssl-error/

require 'open-uri'
require 'net/https'

module Net
  class HTTP
    alias_method :original_use_ssl=, :use_ssl=

    def use_ssl=(flag)
      #we provide our own certs to workaround different OS paths for the CACert
      #Certs retrieved from http://curl.haxx.se/ca/cacert.pem
      self.ca_file = Rails.root.join('lib','certs','cacert.pem').to_s

      self.verify_mode = OpenSSL::SSL::VERIFY_PEER
      self.original_use_ssl = flag
    end
  end
end