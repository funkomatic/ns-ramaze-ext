

##
## Our Bananas controller illusrrating form handling 
## for data model creation and validation.
##
## The form is in the views/bananas/new.rhtml
##

class Bananas < Controller
  ## use the helper
  helper :banana_form
  
  ## create a new banana and render form
  def new
    @banana = Banana.new
  end
  
  ## save the created banana render a string if sucessful, render back the creation form and display errors if any
  def create
    @banana = Banana.new()
    @banana.color=request[:color]
    @banana.country=request[:country]
    if ( @banana.save)
      "Valid, example over"
    else
      render_view(:new)
    end  
  end
end

##
## Banana is our model class acting as a class from an ORM that provides
## validation and error stacking in a hash.
##
## The validation is simple : 
##   - color must be provided
##   - country must be provided
class Banana
  attr_accessor :color
  attr_accessor :country
  
  def initialize params=nil
    super(params) if params
    @errors = {}
  end
  
  ## validation sim
  def validate
    ret=true
    if ( @color == nil or ( @color!=nil and @color.size==0 ) )
      @errors[:color]="must be provided"
      ret=false
    end
    if ( @country == nil or ( @country=nil and @country.size==0 ) )
      @errors[:country]="must be provided"
      ret=false
    end
    ret
  end
  
  ## save if valid
  def save
    return validate
  end
  
  def errors
    @errors
  end
  
end