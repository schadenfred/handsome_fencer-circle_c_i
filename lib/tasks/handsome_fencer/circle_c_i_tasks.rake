desc "obfuscate .circleci variables"
namespace "handsome_fencer" do
  namespace "circleci" do
    task :obfuscate do
      cipher = Handsomefencer::Environment::Crypto.new
      cipher.obfuscate
    end

    task :expose do
      cipher = Handsomefencer::Environment::Crypto.new
      cipher.expose
    end
  end
end
