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
      test_array = [1, 2, 3, 4, 8, 7, 17, 20, 24, 27, 28, 28, 30, 35, 37, 38]

      @root = build_tree(test_array)
      pretty_print()
      puts height_iterative(@root)
      puts height_recursive(@root)
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
        return root_node
      end
      #    If both left and right attr are nil
      #    Orphan node by selecting parent left/right attr and setting to nil
      if root_node.left.nil? && root_node.right.nil?
        if root_node.data < root_node.parent.data
          root_node.parent.left = nil
        elsif root_node.data > root_node.parent.data
          root_node.parent.right = nil
        end
      #    If two children with non-nil data
      elsif root_node.right.data && root_node.left.data
        #    Make root node min_order_node (leftmost node in rightmost subtree)
        #    Delete min_order_node from original position
        min_order_node = min_order(root_node.right)
        temp = min_order_node.data
        delete(temp)
        root_node.data = temp
      #    If non-nil left child
      elsif root_node.left.data
        if root_node.data < root_node.parent.data
          #     Attach node child to parent left if root_node is parent left
          root_node.parent.left = root_node.left
        elsif root_node.data > root_node.parent.data
          #    Attach node child to parent right if root_node is parent rightr
          root_node.parent.right = root_node.left
        end
      #    Same process but for a right child
      elsif root_node.right.data
        if root_node.data < root_node.parent.data
        root_node.parent.left = root_node.right
        elsif root_node.data > root_node.parent.data
          root_node.parent.right = root_node.right
        end
      else
        if root_node.data < root_node.parent.data
          root_node.parent.left = nil 
        elsif root_node.data > root_node.parent.data
          root_node.parent.right = nil
        end
        return root_node.data
      end
    end

    #    Find the leftmost node in any given tree, used in deletion function
    #    For when a node has two children, to find the left-most node in a tree
    def min_order root_node=@root
      current = root_node

      until current.left.nil?
        current = current.left
      end

      return current
    end

    #    If value not equal to current node, recursively iterate through the tree until it is found and return it
    def find value, root_node=@root
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

    def height_iterative root_node
      # Base case
      return 0 if root_node.nil?

      # Create empty array for queue
      queue = [root_node]
      height = 0

      loop do
        node_count = queue.length
        return height if node_count.zero?

        height += 1

        while node_count.positive?
          Node.new new_node = queue[0]
          queue.shift

          queue.append(new_node.left) unless new_node.left.nil?
          queue.append(new_node.right) unless new_node.right.nil?

          node_count -= 1
        end
      end
    end

    def height_recursive root_node
      # Base case
      if root_node.nil?
        return 0
      end

      # Recurse on left child
      left_depth = height_recursive(root_node.left)
      # Recurse on right child
      right_depth = height_recursive(root_node.right)

      # Return whichever depth is greater
      if left_depth > right_depth
        left_depth + 1
      else
        right_depth + 1
      end
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
  end

  Tree.new
end
