namespace "handsome_fencer" do

  namespace "circleci" do

    @cipher = HandsomeFencer::CircleCI::Crypto.new

    desc "obfuscate .circleci variables"
    task :obfuscate do
      @cipher.obfuscate
    end

    desc "expose .circleci variables"
    task :expose do
      @cipher.expose
    end
  end
end
