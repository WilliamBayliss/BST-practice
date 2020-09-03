module BinarySearchTree
  class Node
    attr_accessor :data, :left, :right, :parent

    def initialize data
      @data = data
      @left = nil
      @right = nil
      @parent = nil
    end

    include Comparable
    def <=>(other_data)
      data <=> other_data
    end
  end

  class Tree
    attr_reader :root
    def initialize
      test_array = [1, 2, 3, 4, 8, 7, 17, 20, 24, 27, 30]

      @root = build_tree(test_array)
      delete(20)
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
      root_node.left.parent = root_node
      root_node.right = build_tree(right_array)
      root_node.right.parent = root_node
  
      return root_node
    end
  
    #    Given a value, will insert that value into the binary tree as a new node
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
  
    def delete  node_data, root_node=find(node_data)
      #    Special case, if node is tree root
      if root_node == @root
        @root = null
        return
      end

      if root_node.nil?
        return 1
      end
      #    If node has two children
      if root_node.right && root_node.left
        min_order_node = min_order(root_node.right)
        temp = min_order_node.data
        delete(temp)
        root_node.data = temp
      
        #    Node has no subtrees, orphan node
      elsif root_node.right.nil? && root_node.left.nil?
        if root_node.data < root_node.parent.data
          root_node.parent.left = nil 
        elsif root_node.data > root_node.parent.data
          root_node.parent.right = nil
        end
        return root_node.data
      #    Node has 1 child
      else
          #    If left child exists
          unless root_node.left.nil?
          
            temp = root_node.left.data
            delete(temp)
            root_node.data = temp
            return root_node.data
          end
          unless root_node.right.nil?
            temp = root_node.right.data
            delete(temp)
            root_node.data = temp
            return root_node.data
          end
        end
      end
        
    
    def find value, root_node=@root
      #    If value not equal to current node, recursively iterate through the tree until it is found and return it
      case value <=> root_node.data
        when -1
          find(value, root_node.left)
        when 1
          find(value, root_node.right)
        when 0
          return root_node
        else
          return
      end
    end

    #    Find the leftmost node in any given tree, used in deletion function
    #    For when a node has two children
    def min_order root_node=@root
      current = root_node

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