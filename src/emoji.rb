class Emoji
  def emojis
    @emojis
  end

  def initialize(query = '')
    @emojis = load_emojis
    select!(query.split)
  end
  
  def load_emojis
    Dir.glob("./emoji/*.png").map do |path|
      File.basename(path, ".png")
    end.compact.uniq.sort
  end
  
  def add_items(feedback, emojis = @emojis)
    emojis.each { |emoji| feedback.add_item(item_hash(emoji)) }
    feedback
  end
  
  def to_alfred(alfred)
    add_items(alfred.feedback).to_alfred
  end

  def select!(queries, emojis = @emojis)
    queries.each do |q|
      # use reject! for ruby 1.8 compatible
      emojis.reject! do |i|
        i.index(q.downcase) ? false : true
      end
    end
  end

  def item_hash(emoji)
    {
      :uid      => "",
      :title    => emoji,
      :subtitle => "Copy to clipboard :#{emoji}:",
      :arg      => emoji,
      :icon     => { :type => "default", :name => "./emoji/#{emoji}.png" },
      :valid    => "yes",
    }
  end
end