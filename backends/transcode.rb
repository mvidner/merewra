class Transcode < Backend
  def process(profile, in_fname, out_fname)
    vcodec = "null"
    acodec = "null"
    if profile.vcodec == "s263" and profile.acodec == "samr"
      raise "not implemented yet"
    else
      case profile.vcodec
      when nil
        # none is OK
      when "divx"
        vcodec = "xvid4"
      else
        raise "Cannot handle video codec #{profile.vcodec}"
      end

      case profile.acodec
      when "mp3"
#        opts "-E 16000" # for a720 input
        acodec = "lame"         # FIXME needs the lame binary
        # implied by xvid
      when "aac"
        raise KnownUnsupported
      else
        raise "Cannot handle audio codec #{profile.acodec}"
      end
    end
    opts "-y #{vcodec},#{acodec}"
    run ["transcode", "-i", in_fname, "-o", out_fname] + @options
  end
end
