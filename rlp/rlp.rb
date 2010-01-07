module ACN
  class PDU
    attr_accessor :flags
    attr_accessor :length
    attr_accessor :header
    attr_accessor :vector
    attr_accessor :data
    
    def pack
    end
    
    def self.unpack(data)
    end
    
  end
  
  class Packet
  end
  
end