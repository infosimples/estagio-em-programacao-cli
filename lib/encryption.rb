module Encryption
  LOCAL_KEY  = "z\x94\x13\x8Csa\x06\xC7G\xDC\t5\x03\xDC\x95\xC9H\xCE\xF4\x94I\xB1\xB5|0\xF3\xA8\x9EFOP\x87\x13\ns\xD6\xB3\x9D3\x93\x16\xB3\x97\xBDs\x9Ch\xC6;\xC4\xF1m(x\xCF\x1C\xD5\x8B\x88\xEFo\x91\x192\"\xDE\x19\xEE\xF6\xDCT\xC3\xBA\xBF0\xA5\xD2\x0E\xFD@'{\xE4\xFA\xFC\xE5\xAB\x1D,\xC7O\xF0\xADS]A=\x91\x18\xBC\xA8\x89j\xD1\xE6S\xC91\xE4K\x80\x11\xA7\x19\x95Ghv\x90\xD8\xBBq\x8A\x12\x10-\x95\x0EG\xBDk\xE1l\xFB>@\xC7&N\xB9\xCE\xD5\x13\x10\xA0\xE9\x15Q\xEF{\x91\x9E\xF7\xDB\x8CK.h\xE6t)D\x89\x83$R=_\x83}\xE8\x1Fr=\xF9+\xBD\x15\xD53\x06\xFAz:n\xBFn\x16\xEE\x01 \xDE\x16\xF7y\x81\xF2H8\xBB`\x91\xCC\xAB\xBE\x98p&^w\xEB\x15\xEB\xCCE\x1E\x1Cg:\xA2&\x06\xFFf\xD5\x17+\xCCy\xBD\xEC\xE4\xE61qhK\xC4\xF8\xFC\xDB\xBD\xAB&*l\xD8\xA7\x96S\xB1L\x8F\xEC\x9A\x9E"
  LOCAL_IV   = "\xA8\xF9\xD4\xDB0\x88,Rl\xCE\xBD~'\xB4R\xA5"
  REMOTE_KEY = "TODO----------------------------------------------------------"
  REMOTE_IV  = "TODO----------------------------------------------------------"

  def self.encrypt(data, local_mode: true)
    cipher = create_cipher(:encrypt, local_mode)

    encrypted = cipher.update(data)
    encrypted << cipher.final
  end

  def self.decrypt(data, local_mode: true)
    cipher = create_cipher(:decrypt, local_mode)

    decrypted = cipher.update(data)
    decrypted << cipher.final
  end

  private

  def self.create_cipher(op, local_mode)
    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')

    case op
    when :encrypt then cipher.encrypt
    when :decrypt then cipher.decrypt
    else fail "Unknown operation: #{op}"
    end

    # Load key and i.v. into cipher
    cipher.key =  local_mode ? LOCAL_KEY : REMOTE_KEY
    cipher.iv  =  local_mode ? LOCAL_IV : REMOTE_IV

    cipher
  end
end
