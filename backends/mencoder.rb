class Mencoder < Backend
  def initialize
    super
    @lavcopts = []
  end

  def opts(string)
    @lavcopts += string.split
  end

  def process(profile, in_fname, out_fname)
    if profile.vcodec == "s263" and profile.acodec == "samr"
      opts "-oac lavc -ovc lavc -af resample=8000,channels=1 -srate 8000 -lavcopts vcodec=h263:acodec=libamr_nb:abitrate=8"
    else
      case profile.vcodec
      when nil
        # none is OK
      when "divx"
        opts "-ovc lavc"
        lavcopts "vcodec=mpeg4"
      when "theora"
        opts "-ovc lavc"
        lavcopts "vcodec=libtheora"
      else
        raise "Cannot handle video codec #{profile.vcodec}"
      end

      case profile.acodec
      when "mp3"
        opts "-af resample=16000" # for a720 input
        opts "-oac mp3lame"  # -lameopts preset=standard"
      when "vorbis"
        opts "-oac lavc"
        lavcopts "acodec=vorbis"
      when "aac"
        raise KnownUnsupported
# from ffmpeg
#      when "wmav2", "aac"
#        opts "-acodec #{profile.acodec}"
      else
        raise "Cannot handle audio codec #{profile.acodec}"
      end
    end

    unless profile.width.nil? or profile.height.nil?
      opts "-vf scale=#{profile.width}:#{profile.height}"
    end

    unless @lavcopts.empty?
      opts "-lavcopts #{@lavcopts.join ':'}"
    end
    opts "-v" # verbose
    run ["mencoder", in_fname, "-o", out_fname] + @options
  end
end
