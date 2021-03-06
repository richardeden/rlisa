require "enumerator"

class Float
 def ensure_bound(min, max)
   [[self, min].max, max].min
 end
end

class Candidate
  
  attr :difference, true
  attr :genestring
  
  POLYGONS = 50
  VERTEX_COUNT = 8
  POLYGON_LENGTH = VERTEX_COUNT * 2 + 4
  
  def initialize(genestring = nil, &block)
    block ||= lambda { 0.5 }
    if genestring
      @genestring = genestring.dup
    else 
      @genestring = Array.new(POLYGONS * POLYGON_LENGTH, &block)
    end
  end
  
  def self.procreate(mum, dad)
    genes = []
    genes = mum.genestring.dup
    start = ((rand * mum.genestring.size).to_i / (POLYGON_LENGTH*2)).to_i * POLYGON_LENGTH
    genes[start,genes.size/2] = dad.genestring[start,genes.size/2]
    baby = Candidate.new(genes)
      2.times { baby.mutate! }
    baby
  end
    
  def mutate!
    @difference = nil
    seed = (rand * @genestring.size).to_i
    20.times do |x|
      gene_to_mutate = (seed + x) % @genestring.size
      @genestring[gene_to_mutate] += (rand * 0.05) - 0.025
      @genestring[gene_to_mutate].ensure_bound(0.0, 1.0)
    end
    self
  end
  
  def draw
  	glClear(GL_COLOR_BUFFER_BIT)
    @genestring.each_slice(POLYGON_LENGTH) do |polystring|
      glColor4f(polystring[0], polystring[1], polystring[2], polystring[3] / 2)
      glBegin(GL_POLYGON)
      polystring[4..-1].each_slice(VERTEX_COUNT * 2) do |vs|
        vs.each_slice(2) do |xy|
        	glVertex(xy[0] * 2.0 - 1.0, xy[1] * 2.0 - 1.0)
        end
      end
    	glEnd
    end
  end
  
end
  