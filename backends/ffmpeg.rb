class Ffmpeg < Backend
  def process(profile, in_fname, out_fname)
    if profile.vcodec == "s263" and profile.acodec == "samr"
      opts "-s qcif -acodec libamr_nb -ar 8000 -ac 1 -ab 7950"
    else
      case profile.vcodec
      when nil
        opts "-vn"
      when "divx"
        opts "-y xvid4" # bogus, from Transcode
      when "theora"
        opts "-vcodec libtheora -sameq"
      else
        raise "Cannot handle video codec #{profile.vcodec}"
      end

      case profile.acodec
      when nil
        opts "-an"
      when "mp3"
        opts "-acodec libmp3lame"
      when "vorbis"
        opts "-acodec vorbis -ac 2"
      when "wmav2", "aac"
        # a720 input has audio rate 11020 which is invalid for aac. use -ar how much?
        opts "-acodec #{profile.acodec}"
      else
        raise "Cannot handle audio codec #{profile.acodec}"
      end
    end
    case profile.container
    when nil
      #nothing
    when "mp4", "ogg", "asf"
      opts "-f #{profile.container}"
    end
    run ["ffmpeg", "-y", "-i", in_fname] + @options + [out_fname]
  end
end
