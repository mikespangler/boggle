WORDS = File.readlines('words.txt').map(&:strip)

class Trie
  attr_accessor :tree

  def initialize
    @tree = {}
    WORDS.each { |word| self.add(word) }
  end

  def add(word, node = @tree)
    if word.length == 0
      node[:end] = true
    else
      first = word[0]
      rest = word[1..-1]
      node[first] ||= {}
      add(rest, node[first])
    end
  end
end

class Node
  attr_accessor :row, :column, :square, :dictionary_node, :parent, :visited
  def initialize(row, column, square, dictionary_node, parent, visited = [])
    @row = row
    @column = column
    @square = square
    @dictionary_node = dictionary_node
    @parent = parent
  end
end

def boggle(board, dictionary)
  queue, words = [],[]
  neighbor_coordinates = [[1,0],[-1,0],[0,1],[0,-1],[1,1],[-1,-1],[-1,1],[1,-1]]
  
  (0..3).each do |row|
    (0..3).each do |column|
      square = board[row][column]
      dictionary_node = dictionary[square]
      parent = nil
      queue << Node.new(row, column, square, dictionary_node, parent)
    end
    
  end

  while queue.any?
    current_node = queue.pop
    neighbor_coordinates.each do |x,y|
      row2 = current_node.row + x
      column2 = current_node.column + y

      if [row2,column2].all? { |index| index.between?(0,3) }
        next_square          = board[row2][column2]
        next_dictionary_node = current_node.dictionary_node[next_square]
        parent = current_node

        if next_dictionary_node
          new_node = Node.new(row2, column2, next_square, next_dictionary_node, parent)
          if (next_dictionary_node[:end] == true) && unique_path?(new_node)
              words << build_word(new_node)
          end
          queue << new_node
        end
      end
    end
  end
  words.uniq
end

def build_word(node, word = [])
  word.unshift(node.square)
  return word.join if !node.parent
  build_word(node.parent, word)
end

def unique_path?(node, word = [])
  word << [node.row, node.column]
  if !node.parent
    return word.detect{ |pos| word.count(pos) > 1 } ? false : true
  end
  unique_path?(node.parent, word)
end

def board
  [
    ['n','o','c','b'],
    ['p','o','m','o'],
    ['e','p','i','u'],
    ['n','s','a','t']
  ]
end

t = Trie.new
print boggle(board, t.tree)
