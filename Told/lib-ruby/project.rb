include Java

include_class javax.xml.parsers.DocumentBuilderFactory
include_class javax.xml.parsers.ParserConfigurationException
include_class javax.xml.parsers.DocumentBuilder

include_class javax.xml.transform.TransformerConfigurationException
include_class javax.xml.transform.TransformerException
include_class javax.xml.transform.Source
include_class javax.xml.transform.dom.DOMSource
include_class javax.xml.transform.Result
include_class javax.xml.transform.stream.StreamResult
include_class javax.xml.transform.Transformer
include_class javax.xml.transform.TransformerFactory
include_class javax.xml.transform.OutputKeys

include_class org.xml.sax.SAXParseException
include_class org.xml.sax.SAXException

include_class org.w3c.dom.Document
include_class org.w3c.dom.NamedNodeMap
include_class org.w3c.dom.Node
include_class org.w3c.dom.NodeList

include_class "hk.edu.cuhk.cse.told.Footprint"

require 'grammar/grammar.rb'
require 'grammar/semantic.rb'

class Project
  
  TOLD_FILE_FORMAT = "0.8"
  
  class XmlProcessor
  # adopt from Sun's JAXP example
    
    def self.create_multiline_nodes(document, text)
      nodes = []
      text.each_line do |l|
        line = document.createElement("line")
        #line.appendChild(document.createTextNode(l.chomp))
        line.appendChild(document.createCDATASection(l.chomp))
        nodes.push(line)
      end
      nodes
    end
    
    def self.parse_multiline_nodes(nodes)
      text = ""
      unless nodes.nil?
        0.upto(nodes.getLength - 1) do |i|
          unless nodes.item(i).nil?
            if nodes.item(i).getFirstChild.nil?
              if (nodes.item(i).getNodeName == "line")
                # empty lines
                text += "\n"
              end
            else
              text += nodes.item(i).getFirstChild.getNodeValue + "\n"
            end
          end
        end
      end
      text.chomp
    end
    
    def self.create_heredoc(document, text)
      # escape cdata ending sequence
      escaped = text.gsub(/\]\]>/, "]] >")
      document.createCDATASection("\n#{escaped}\n")
    end
    
    def self.parse_heredoc(nodes)
      text = ""
      if nodes.getLength == 1 and nodes.item(0).getNodeType == org.w3c.dom.Node::CDATA_SECTION_NODE
        text = nodes.item(0).getNodeValue.strip
      else
        text = parse_multiline_nodes(nodes)
      end
      text
    end

    def self.parse(filename)
      document = nil
      
      # create document factory
      factory = DocumentBuilderFactory.newInstance
  
      factory.setValidating(false)
      factory.setNamespaceAware(true)
      factory.setCoalescing(false)
      factory.setIgnoringElementContentWhitespace(true)
  
      begin
        # Get DocumentBuilder
        builder = factory.newDocumentBuilder
        # Parse and load into memory the Document
        document = builder.parse(java.io.File.new(filename))
        return document
      rescue SAXParseException
        raise "File #{filename} is not a valid TOLD Project File"
      rescue
        raise "Project File #{filename} no longer exists"
      end
  
      return nil
    end
    
    def self.write_file(filename, document)
      begin
        # Prepare the DOM document for writing
        source = DOMSource.new(document)
  
        # Prepare the output file
        file = java.io.File.new(filename)
        result = StreamResult.new(java.io.OutputStreamWriter.new(java.io.FileOutputStream.new(file),"UTF-8"))
  
        # Write the DOM document to the file
        # Get Transformer
        
        factory = TransformerFactory.newInstance
        factory.setAttribute("indent-number", "2")
        
        xformer = factory.newTransformer
        xformer.setOutputProperty(OutputKeys::METHOD, "xml")
        xformer.setOutputProperty(OutputKeys::INDENT, "yes")
        xformer.setOutputProperty(OutputKeys::ENCODING, "UTF-8");
        xformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2")
        # Write to a file
        xformer.transform(source, result)
      rescue 
        raise "Error occured while the project is being saved"
      end
  
    end
  end
  
  attr_accessor :grammar
  attr_accessor :property_values
  attr_accessor :codes
  attr_accessor :footprint
  
  FILE_SUFFIX = ".told"

  def initialize()
    @property_values = {
                         "project_name" => "Untitled",
                         "author" => "",
                         "description" => "",
                         "symbol_table_type" => 0,
                         "manual_space" => 0
                       }
    @grammar = Grammar.new
    @codes = Array.new
    @codes.push("")
    @footprint = Footprint.newFootprint
  end
  
  def self.read_file(filename)
    project = self.new
    document = XmlProcessor.parse(filename)
    
    # extract document property
    property_nodes = document.getElementsByTagName("property").item(0)
    if property_nodes
      0.upto(property_nodes.getChildNodes.getLength - 1) do |i|
        node = property_nodes.getChildNodes.item(i)
        node_type = node.getNodeType
        if node_type == Document::ELEMENT_NODE
          node_name = node.getNodeName
          if node_name == "description"
            project.property_values[node_name] = XmlProcessor.parse_heredoc(node.getChildNodes)
          elsif node.getFirstChild != nil
            project.property_values[node_name] = node.getFirstChild.getNodeValue
          end
        end
      end
    end

    root = document.getElementsByTagName("project").item(0)
#    if root.hasAttribute("footprint")
#      project.footprint = root.getAttribute("footprint")
#    else
#      project.footprint = Footprint.modifiedFootprint
#    end
    
    # extract grammar
    source_node = document.getElementsByTagName("source").item(0)
    project.grammar.source = XmlProcessor.parse_heredoc(source_node.getChildNodes)
    
    # extract semantics
    semantic_nodes = document.getElementsByTagName("semantic")
    0.upto(semantic_nodes.getLength - 1) do |i|
      node = semantic_nodes.item(i)
      semantic_name = node.getAttribute("name")
      evaluation_content = ""
      typechecking_content = ""
      content_nodes = node.getChildNodes
      0.upto(content_nodes.getLength - 1) do |j|
        content_node = content_nodes.item(j)
        if content_node.getNodeName == "evaluation"
          evaluation_content = XmlProcessor.parse_heredoc(content_node.getChildNodes)
        elsif content_node.get_node_name == "typechecking"
          typechecking_content = XmlProcessor.parse_heredoc(content_node.getChildNodes)
        else
          # raise exception
        end
      end
      semantic = Semantic.new(semantic_name)
      semantic.evaluation = evaluation_content
      semantic.typechecking = typechecking_content
      project.grammar.semantics[semantic_name] = semantic
    end
    
    # extract sample code
    code_nodes = document.getElementsByTagName("code")
    if code_nodes.getLength > 0
      project.codes[0] = XmlProcessor.parse_heredoc(code_nodes.item(0))
    end
    
    project
  end
  
  def write_file(filename)
    builder = nil
    factory = DocumentBuilderFactory.newInstance()
    begin
      builder = factory.newDocumentBuilder
      document = builder.newDocument
    rescue 
      raise "Error occured while the project is being saved"
    end
    
    # update footprint
    #@footprint = Footprint.updateFootprint(@footprint, @property_values["author"], self.size)
    
    # root element
    root = document.createElement("project")
    root.setAttribute("version", TOLD_FILE_FORMAT)
    #root.setAttribute("footprint", @footprint)
    #root.setAttribute("basepath", @base_path)
    document.appendChild(root)
    
    # insert property
    property_node = document.createElement("property")
    root.appendChild(property_node)
    @property_values.each_pair do |prop, value|
      node = document.createElement(prop)
      property_node.appendChild(node)
      if prop == "description"
        node.appendChild(XmlProcessor.create_heredoc(document, value))
      else
        node.appendChild(document.createCDATASection(value.to_s))
      end
    end
    
    # insert grammar
    grammar_node = document.createElement("grammar")
    root.appendChild(grammar_node)
    
    # insert grammar symbol
    source_node = document.createElement("source")
    grammar_node.appendChild(source_node)
    source_node.appendChild(XmlProcessor.create_heredoc(document, @grammar.source))
    
    # insert semantics  
    semantics_node = document.createElement("semantics")
    grammar_node.appendChild(semantics_node)
    @grammar.semantics.each_pair do |k, v|
      node = document.createElement("semantic")
      node.setAttribute("name", k)
      semantics_node.appendChild(node)

      # evaluation
      evaluation_node = document.createElement("evaluation")
      node.appendChild(evaluation_node)
      evaluation_node.appendChild(XmlProcessor.create_heredoc(document, v.evaluation))
      
      # type checking
      typechecking_node = document.createElement("typechecking")
      node.appendChild(typechecking_node)
      typechecking_node.appendChild(XmlProcessor.create_heredoc(document, v.typechecking))
      
    end
    
    # insert sample code
    codes_node = document.createElement("codes")
    root.appendChild(codes_node)
    @codes.each do |c|
      node = document.createElement("code")
      codes_node.appendChild(node)
      node.appendChild(XmlProcessor.create_heredoc(document, c))
#      XmlProcessor.create_multiline_nodes(document, c).each do |n|
#        node.appendChild(n)
#      end
    end
    
    document.getDocumentElement.normalize
    
    XmlProcessor.write_file(filename, document)
    
  end
  
  def size
    @grammar.size
  end
  
  def to_s
    "Project: #{name}"
  end
  
end