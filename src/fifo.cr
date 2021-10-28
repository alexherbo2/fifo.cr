class FIFO
  property path

  def reader
    File.new(path, "r")
  end

  def writer
    File.new(path, "w")
  end

  def initialize(@path : Path)
    create unless exists?
  end

  def self.new(path : String)
    new(Path[path])
  end

  def self.new
    new(Path[File.tempname])
  end

  def create
    LibC.mkfifo(path.to_s, 0o0600)
  end

  def delete
    File.delete(path)
  end

  def exists?
    File.exists?(path)
  end

  def consume(&block)
    value = yield self
    delete
    value
  end

  def self.consume(&block)
    new.consume do |fifo|
      yield fifo
    end
  end
end
