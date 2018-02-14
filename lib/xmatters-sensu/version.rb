#
# XMSensu
#
module XMSensu
  #
  # XMSensu::Version
  #
  module Version
    #
    # MAJOR Version
    #
    MAJOR = 0
    #
    # MINOR Version
    #
    MINOR = 0
    #
    # PATCH Version
    #
    PATCH = 5

    #
    # Formatted Version String
    #
    VER_STRING = [MAJOR, MINOR, PATCH].compact.join('.')
  end
end
