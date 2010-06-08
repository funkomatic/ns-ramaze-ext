require 'ramaze'
require 'ramaze/gestalt'

module Ramaze
  module Helper

    ## = Banana Form Helper
    ##
    ## == Overview
    ##
    ## The banana form heloer is derived from the ramaze standard BlueForm helper.
    ##
    ## == Features:
    ##
    ## * provide additional parameters for form element css class styling
    ##
    ## * provide form error management that includes an error summary and css
    ##   style changing on impacted fields, very much like the rails view helper
    ##
    ## == Styling
    ##
    ## All the BananaForm::Form methods accept the following parameters for css styling :
    ##
    ## * *class*       : class for the input element
    ## * *class_label* : class for the input label
    ## * *class_error* : class for input in case of validation errors on that field
    ## * *class_label_error* : class for the label if any validation errors occur on the related input field
    ##
    ## == Error Handling
    ##
    ## The errors are declared in the very same way that in the BlueFrom, however the form
    ## behavior is different.
    ##
    ## If errors have been declared, prior to form construction, the form helper class
    ## will check the existing errors and corelate them with input fields.
    ##
    ## The labels and fields linked to the errors will have their class attribute changed
    ## in order to apply some highlighting or any other presentation layer that would provide
    ## the user with hints.
    ##
    ## Further, the form will have a div section that will display an error summary very similar
    ## to the one provided by rails view helper.
    ##
    ## All styles, including the summary related can be overridden by providing the appropriate
    ## parameters in the Ramaze::Helper::BananaForm::Form methods.
    ##
    ## Please note that the gem and helper don't provide any of the css styles and that we consider
    ## that this is part of your job.
    ##
    ## === Declaring Errors
    ##
    ## The errors are declared *before* the form is constructed using the following module methods :
    ##
    ## * Ramaze::Helper::BananaForm.form_error : adds a new error with name and message
    ##
    ## * Ramaze::Helper::BananaForm.form_errors_from_model : adds all the errors contained in a 'model' class instance (i.e providing errors hash)
    ##  
    ##
    ## Please note that those are the same methods than in *BlueForm*, and that the source code is unchanged.
    ##
    ## === Error Summary Default Properties
    ##
    ## The summary will be inserted as a div element *before* the fieldset tag.
    ##
    ## Default *id* and *class* are set to the *form_error_summary* value. If you want to see something
    ## fancy in a minimum laps of type just copy the rails *errorExplanation* style to *form_error_summary* and
    ## include it in your form page.
    ##
    ## === Default Field and Labels styles
    ##
    ## The form construction is managed by the Ramaze::Helper::BananaForm::Form class, so please check the documentation
    ## of the class methods in order to find out the default styles.
    ##
    ## == Examples
    ##
    ## There are a bunch of examples in the specs located under the test directory of the gem.
    ## It is probably your best way into BananaForm ...
    ##

    module BananaForm
      
      ## == Constructs a new form 
      ## 
      ## Constructs a form with options and an optional block that will provide content
      ##
      ## === Example :
      ##
      ## form(:method => :post, :action => :create, :name => 'user' ) do |f|
      ##  f.legend('User Details')
      ##  f.input_text 'Username', :username, @user.username
      ##  f.input_submit 'Create New User'
      ## end
      ##
      ## === Note :
      ##
      ## In a templating engine, you need to do this with an assignement statement.
      ## For instance with Erubis it would look like this :
      ##
      ## <%=
      ##  form(:method => :post, :action => :create, :name => 'user' ) do |f|
      ##    ...
      ##  end
      ## %>
      ##
      def form(options = {}, &block)
        form = Form.new(options)
        form.build(form_errors, &block)
        form
      end

      ## == Adds an error to be managed by the form helper
      ##
      ## Uses flash[:form_errors] placeholder is flash is available,
      ## creates an empty hash if not.
      ##
      ## Errors are stored as key/values of the hash.
      ##
      def form_error(name, message)
        if respond_to?(:flash)
          old = flash[:form_errors] || {}
          flash[:form_errors] = old.merge(name.to_s => message.to_s)
        else
          form_errors[name.to_s] = message.to_s
        end
      end

      ## == Returns the error hash
      ##
      ## Code inherited from Ramaze::Helper::BlueForm seems to return the used error hash.
      ##
      def form_errors
        if respond_to?(:flash)
          flash[:form_errors] ||= {}
        else
          @form_errors ||= {}
        end
      end

      ## == Adds errors contained in a model instance
      ##
      ## The method assumes that the object reference you're passing as argument
      ## responds to a method named *errors* that return a Hash of errors
      ##
      ## It iterates over errors and call the form_error method to insert each error
      ##
      def form_errors_from_model(obj)
        obj.errors.each do |key, value|
          form_error(key.to_s, value.first % key)
        end
      end

      ## == Banana form helper manager class
      ##
      ## Provide methods to build a form and use the banana error handling features.
      ##
      ## == Notes
      ##
      ## This code is based on the Ramaze::Helper::BlueForm::Form class and *is not thread safe* , so make sure
      ## you're not using it from several execution threads.
      ##
      class Form

        ## Gestalt HTML Builder
        attr_reader :g
        ## Structure containing the summary parameters before final construction
        attr_reader :error_summary_args

        ## == Initializes an instance of the class
        ##
        ## Accepts following extra parameters for error summary :
        ##
        ## * *error_summary_title*    : sets the main summary title, defaults to "X error(s) prohibited this form from being saved" where X is the number of errors
        ##
        ## * *error_summary_subtitle* : sets the subtitle of the summary title, default to 'Following fields reported errors:'
        ##
        ## * *error_summary_class*    : sets the summary div class, defaults to 'form_error_summary'
        ##
        ## * *error_summary_id*    : sets the summary div id, defaults to 'form_error_summary'
        ##
        ##
        def initialize(options)
          @form_args = options.dup
          @error_encart_args = {}
          @error_encart_args[:title] =  @form_args.delete(:error_summary_title)
          @error_encart_args[:subtitle] = @form_args[:error_summary_subtitle] ? @form_args.delete(:error_summary_subtitle) : 'Following fields reported errors:'
          @error_encart_args[:class] = @form_args[:error_summary_class] ? @form_args.delete(:error_summary_class) : 'form_error_summary'
          @error_encart_args[:id] = @form_args[:error_summary_id] ? @form_args.delete(:error_summary_id) : 'form_error_summary'
          @g = Gestalt.new
          @error_encart = nil
        end

        ## == Builds the form
        ##
        ## Builds the form (and summary), sets up the errors from module error holder
        ##
        ## Called by form method, should not be invoked from outside.
        ##
        def build(form_errors = {})
          @form_errors = form_errors
          @g.form(@form_args) do
            ## form validation summary
            if (  @form_errors!=nil && @error_encart_args && @form_errors.size>0)
              @error_encart_args[:title] = "#{@form_errors.size} error(s) prohibited this form from being saved" unless @error_encart_args[:title]
              @g.div(:id=>@error_encart_args[:id],:class=>@error_encart_args[:class]) {
                @g.h2("#{@error_encart_args[:title]}")
                @g.p("#{@error_encart_args[:subtitle]}")
                @g.ul() {
                  @form_errors.each_pair { |name, val| @g.li("#{name} : #{val}")  }
                }
              }
            end
            ## now yeld block instructions
            if block_given?
              @g.fieldset do
                yield self
              end
            end
          end
        end

        ## == Places a legend over the form fieldset
        ##
        ## Params:
        ##
        ## *text* : legend to display
        ##
        def legend(text)
          @g.legend(text)
        end

        ## == Creates a text input field
        ##
        ## Creates a label and an input field of type 'text'.
        ##
        ## ==== Default styles :
        ##
        ## * input field is set to *text_input* class unless *class* is provided in the args hash
        ##
        ## * label field is set to *text_label* class unless *class_label* is provided in the args hash
        ##
        ## ==== Error styles :
        ##
        ## If an error occurs then both class names will be appended with a _error ( text_input will become text_input_error ... ).
        ##
        ## You can override those by providing *class_error* and *class_label_error* params in the args hash.
        ##

        def input_text(label, name, value = nil, args = {})
          id = id_for(name)
          args = args.merge(:type => :text, :name => name, :id => id)
          args[:value] = value unless value.nil?
          ## set up style classes, delete errors and clean additional params
          css_classes = get_css_classes_clean(name,args)
          args[:class] = css_classes[:input_class]
          @g.p do
            label_for(id, label, name, :class=>css_classes[:label_class])
            @g.input(args)
          end
        end
        alias text input_text

        ## == Creates a password input field
        ##
        ## Creates a label and an input field of type 'password'.
        ##
        ## ==== Default styles :
        ##
        ## * input field is set to *text_input* class unless *class* is provided in the args hash
        ##
        ## * label field is set to *text_label* class unless *class_label* is provided in the args hash
        ##
        ## ==== Error styles :
        ##
        ## If an error occurs then both class names will be appended with a _error ( text_input will become text_input_error ... ).
        ##
        ## You can override those by providing *class_error* and *class_label_error* params in the args hash.
        ##

        def input_password(label, name, args={})
          id = id_for(name)
          args = args.merge(:type => :password, :name => name, :id => id)
          ## set up style classes, delete errors and clean additional params
          css_classes = get_css_classes_clean(name,args)
          args[:class] = css_classes[:input_class]
       
          @g.p do
            label_for(id, label, name,:class=>css_classes[:label_class])
            @g.input(args)
          end
        end
        alias password input_password

        ## == Creates a submit button
        ##
        ## Creates a submit button
        ##
        ## ==== Default styles :
        ##
        ## * buton is set to  *button_submit* class unless *class* is provided in the args hash
        ##
        def input_submit(value = nil, args={})
          args = args.merge(:type => :submit)
          args[:class] = 'button_submit' unless args[:class]
          args[:value] = value unless value.nil?
          @g.p do
            @g.input(args)
          end
        end
        alias submit input_submit


        ## == Creates a checkbox input field
        ##
        ## Creates a label and an input field of type 'checkbox'.
        ##
        ## ==== Default styles :
        ##
        ## * input field is set to *checkbox_input* class unless *class* is provided in the args hash
        ##
        ## * label field is set to *checkbox_label* class unless *class_label* is provided in the args hash
        ##
        ## ==== Error styles :
        ##
        ## If an error occurs then both class names will be appended with a _error ( checkbox_input will become checkbox_input_error ... ).
        ##
        ## You can override those by providing *class_error* and *class_label_error* params in the args hash.
        ##
        def input_checkbox(label, name, checked = false, args={})
          id = id_for(name)
          args= args.merge(:type => :checkbox, :name => name, :id => id)
          args[:checked] = 'checked' if checked

          ## set up style classes, delete errors and clean additional params
          css_classes = get_css_classes_clean(name,args,'checkbox_input','checkbox_label')
          args[:class] = css_classes[:input_class]

          @g.p do
            label_for(id, label, name, :class=>css_classes[:label_class])
            @g.input(args)
          end
        end
        alias checkbox input_checkbox

        ## == Creates a group of radio buttons 
        ##
        ## Creates a label and an input field of type 'checkbox'.
        ##
        ## ==== Default styles :
        ##
        ## * input field is set to *radio_input* class unless *class* is provided in the args hash
        ##
        ## * label field is set to *radio_label* class unless *class_label* is provided in the args hash
        ##
        ## ==== Error styles :
        ##
        ## At the difference of other methods, only the class of the *checked* input field will change in case of errors.
        ##

        def input_radio(label, name, values, options = {})
          has_checked, checked = options.key?(:checked), options[:checked]

          ## not using the usual css error formatter for radio 
          input_class = options[:class] ? options[:class] : 'radio_input'
          label_class = options[:class_label] ? options[:class_label] : 'radio_label'
          error = @form_errors.delete(name.to_s)

          @g.p do
            values.each_with_index do |(value, o_name), index|
              o_name ||= value
              id = id_for("#{name}-#{index}")

              o_args = {:type => :radio, :value => value, :id => id, :name => name}
              o_args[:checked] = 'checked' if has_checked && value == checked

              clazz_elem = (error && has_checked && value == checked ) ? "#{input_class}_error" : input_class
              all_args = o_args.clone
              all_args[:class] = clazz_elem

              @g.label(:for=>id,:class=>label_class) {
                @g.input(all_args)
                @g.out << o_name
              }
            end
          end
        end
        alias radio input_radio

        ## == Creates a file input field
        ##
        ## Creates a label and an input field of type 'checkbox'.
        ##
        ## ==== Default styles :
        ##
        ## * input field is set to *file_input* class unless *class* is provided in the args hash
        ##
        ## * label field is set to *file_label* class unless *class_label* is provided in the args hash
        ##
        ## ==== Error styles :
        ##
        ## If an error occurs then both class names will be appended with a _error
        ##
        ## You can override those by providing *class_error* and *class_label_error* params in the args hash.
        ##

        def input_file(label, name, args={})
          id = id_for(name)
          args = args.merge(:type => :file, :name => name, :id => id)

          ## set up style classes, delete errors and clean additional params
          css_classes = get_css_classes_clean(name,args,'file_input','file_label')
          args[:class] = css_classes[:input_class]

          @g.p do
            label_for(id, label, name,:class=>css_classes[:label_class])
            @g.input(args)
          end
        end
        alias file input_file

        ## == Creates a hidden input field
        ##
        ## Creates a label and an input field of type 'hidden', no styling applies
        ##
        def input_hidden(name, value = nil)
          args = {:type => :hidden, :name => name}
          args[:value] = value.to_s unless value.nil?

          @g.input(args)
        end
        alias hidden input_hidden

        ## == Creates a text area input field
        ##
        ## Creates a label and an input field of type text area.
        ##
        ## ==== Default styles :
        ##
        ## * input field is set to *area_input* class unless *class* is provided in the args hash
        ##
        ## * label field is set to *area_label* class unless *class_label* is provided in the args hash
        ##
        ## ==== Error styles :
        ##
        ## If an error occurs then both class names will be appended with a *_error*
        ##
        ## You can override those by providing *class_error* and *class_label_error* params in the args hash.
        ##
        def textarea(label, name, value = nil, options={})
          id = id_for(name)
          args = {:name => name, :id => id }

          css_classes = get_css_classes_clean(name,options,'area_input','area_label')
          args[:class] = css_classes[:input_class]
  
          @g.p do
            label_for(id, label, name,:class=>css_classes[:label_class])
            @g.textarea(args){ value }
          end
        end


        ## == Creates a selection group input
        ##
        ## Creates the labels and an input field for a group selection
        ##
        ## ==== Default styles :
        ##
        ## * input field is set to *select_input* class unless *class* is provided in the args hash
        ##
        ## * label field is set to *select_label* class unless *class_label* is provided in the args hash
        ##
        ## ==== Error styles :
        ##
        ## If an error occurs then both class names will be appended with a *_error*
        ##
        ## You can override those by providing *class_error* and *class_label_error* params in the args hash.
        ##
        def select(label, name, values, options = {})
          id = id_for(name)
          multiple, size = options.values_at(:multiple, :size)

          args = {:id => id}
          args[:multiple] = 'multiple' if multiple
          args[:size] = (size || multiple || 1).to_i
          args[:name] = multiple ? "#{name}[]" : name
          has_selected, selected = options.key?(:selected), options[:selected]
          css_classes = get_css_classes_clean(name,options,'select_input','select_label')
          @g.p do
            label_for(id, label, name,:class=>css_classes[:label_class])
            @g.select args do
              values.each do |value, o_name|
                o_name ||= value
                o_args = {:value => value}
                o_args[:selected] = 'selected' if has_selected && value == selected
                o_args[:class] = css_classes[:input_class]
                @g.option(o_args){ o_name }
              end
            end
          end
        end

        ## == Converts to string
        ##
        ## Returns the string containing the HTML of the form
        ##
        def to_s
          @g.to_s
        end
  
        private

        ##
        ## Handles the CSS classes for labels and input fields
        ## managing the eventual errors style changes
        ##
        ## Returns a hash containing the following keys :
        ##
        ## :input_class => CSS class to apply on the input field
        ## :label_class => CSS class to apply on the label field
        ##
        ## Parameters :
        ##
        ## name    : name of the fields
        ## options : hash of options passed to the field constructor
        ## input_default : default style for input fields (default to text_input )
        ## label_default : default style for labels ( defaults to text_label )
        ##
        def get_css_classes(name,options={},input_default='text_input',label_default='text_label',delete_errors=true)
          ret = {}
          ret[:input_class] = options[:class] ? options[:class] : input_default
          ret[:label_class] = options[:class_label] ? options[:class_label] : label_default
          error = delete_errors ? @form_errors.delete(name.to_s) : @form_errors[name.to_s]
          if ( error )
            ret[:input_class]  = options[:class_error] ? options[:class_error] : "#{ret[:input_class]}_error"
            ret[:label_class]  = options[:class_label_error] ? options[:class_label_error] : "#{ret[:label_class]}_error"
          end
          return ret
        end

        ## shortcut : get css options and clean the used options in the hash
        def get_css_classes_clean(name,options={},input_default='text_input',label_default='text_label',delete_errors=true)
          ret=get_css_classes(name,options,input_default,label_default,delete_errors)
          options.delete(:class_label)
          options.delete(:class_label_error)
          options.delete(:class_error)
          return ret
        end

        ## creates the label for a given field
        def label_for(id, value, name, options = {})
          css_class = options[:class] ? options[:class] : 'label_text'
          @g.label(value,:for=>id,:class=>css_class)
        end

        ## generates the id for a field name
        def id_for(field_name)
          if name = @form_args[:name]
            "#{name}-#{field_name}".downcase.gsub(/_/, '-')
          else
            "form-#{field_name}".downcase.gsub(/_/, '-')
          end
        end
      end
    end
  end
end
