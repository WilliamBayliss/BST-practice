module BinarySearchTree
  class Node
    attr_accessor :data, :left, :right

    def initialize data
      @data = data
      @left = nil
      @right = nil
    end

    include Comparable
    def <=>(other_data)
      data <=> other_data
    end
  end

  class Tree
    attr_reader :root
    def initialize
      test_array = [1, 3, 8, 7, 10, 15, 20, 25, 30]

      @root = build_tree(test_array)
      insert(12)
      insert(4)
      insert(5)
      insert(45)
      insert(126)
      insert(23)
      delete(8)
      pretty_print()
    end
  
    def build_tree array
      array.sort!
      
      size = array.size
      
      if size <= 1
        return Node.new(array[0])
      end
      
      # Find the index of the middle of the array
      length = array.length

      # Odd/even # of items check
      if size % 2 != 0
        center = (size / 2 + 0.5)
      else
        center = (size / 2)
      end
      #    Item of center of the array becomes data for new node
      data = array[center]

      #    Create two arrays, for left and right of center for recursion
      left_array = array[0...center]
      right_array = array[center+1..-1]

      #    Recursively build the tree from the middle of the array out, using recursion to return the nodes you make on each cycle into the tree
      root_node = Node.new(data)
      root_node.left = build_tree(left_array)
      root_node.right = build_tree(right_array)
  
      return root_node
    end
  
    def find value, node=@root
      #    Base case
      #    Check for nil node, or !nil node but nil data as a failsafe
      if node.nil? || node.data.nil?
        return 1
      #    if value found return node
      elsif node.data == value
        return node
      end
      
      #    If value not equal to current node, recursively iterate through the tree until it is found and return it
      if node.data > value
        return find(value, node.left)
      elsif node.data < value
        return find(value, node.right)
      end
    end
  
    def insert  node_data, current_node=@root
      #    New node to be inserted
      new_node = Node.new(node_data)
      #BC recursion
      #    Check for nil node or nil data
      if current_node.nil?
        current_node = new_node
      elsif current_node.data.nil?
        current_node.data = new_node.data
      end
    #    Recursively find an empty branch of the tree
    #    Where root node is less than or greater than new node
    #    and insert it theres

      if new_node.data < current_node.data
        if current_node.left.nil?
          current_node.left = new_node
          current_node.left.data = new_node.data
        elsif current_node.left.data.nil?
          current_node.left.data = new_node.data
        else
        insert(node_data, current_node.left)
        end
      elsif new_node.data > current_node.data
        if current_node.right.nil?
          current_node.right = new_node
          current_node.right.data = new_node.data
        elsif current_node.right.data.nil?
          current_node.right.data = new_node.data
        else
        insert(node_data, current_node.right)
        end
      end
    end
  
    def delete  node_data, root_node=@root, &block
      return root_node if root_node.data.nil?

      case node_data <=> root_node.data
        #    If less than, search left half
        when -1
          delete(node_data, root_node.left)
        #    If greater than, search right half
        when 1
          delete(node_data, root_node.right)
        #    If <=> returns 0, node found
        when 0
          #    No children
          if root_node.left.nil? && root_node.right.nil?
            daddy = find_parent(root_node)
            if daddy.left.data == root_node.data
              daddy.left = nil
            elsif daddy.right.data == root_node.data
              daddy.right = nil
            end
          end

          #    One child

          #    Two children

      end

      root_node
    end

    def find_parent node, root_node=@root
      if root_node.left.data == node.data
        return root_node
      elsif root_node.right.data == node.data
        return root_node
      end

      case node.data <=> root_node.data
      when -1
        find_parent(node, root_node.left)
      when 1
        find_parent(node, root_node.right)
      end
    end
    

    def leftest_node node
      current = node

      until current.left.nil?
        current = current.left
      end

      return current
    end
    #    Prints out visualization of the tree
    def pretty_print(node = @root, prefix = '', is_left = true)
      unless node.right.nil?
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false)
      end
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      unless node.left.nil?
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true)
      end
    end

    def in_order root_node=@root
      in_order(root_node.left)
      print(root_node.data)
      in_order(root_node.right)
    end
      
  
  end

tree = Tree.new
end