###############################################################################
## File branched from Ramaze::Helper::BlueForm spec tests and updated for
## BananaForm features.
## Use it from the gem root by issuing the rake tests command
###############################################################################
require 'lib/ext/ramaze/helper/banana_form.rb'
require 'tempfile'
require 'bacon'
Bacon.summary_at_exit

describe BF = Ramaze::Helper::BananaForm do
  extend BF

  ## Inherited from a very strange comparision from BlueForm
  def assert(expected, output)
    left = expected.to_s.gsub(/\s+/, ' ').gsub(/>\s+</, '><').strip
    right = output.to_s.gsub(/\s+/, ' ').gsub(/>\s+</, '><').strip
    nodiff = left.scan(/./).sort == right.scan(/./).sort
    unless  ( nodiff )
      puts "\nERROR in comparaison\n"
      puts "EXPECTED : #{left}"
      puts "RETURNED : #{right}"
    end
    nodiff.should == true
  end

  ####################################################################
  ## Basic form specs
  ####################################################################

  it 'makes form with method' do
    out = form(:method => :post)
    assert(<<-FORM, out)
<form method="post"></form>
    FORM
  end

  it 'makes form with method and action' do
    out = form(:method => :post, :action => '/')
    assert(<<-FORM, out)
<form method="post" action="/"></form>
    FORM
  end

  it 'makes form with method, action, and name' do
    out = form(:method => :post, :action => '/', :name => :spec)
    assert(<<-FORM, out)
    <form method="post" action="/" name="spec">
    </form>
    FORM
  end

  it 'makes form with class and id' do
    out = form(:class => :foo, :id => :bar)
    assert(<<-FORM, out)
    <form class="foo" id="bar">
    </form>
    FORM
  end

  it 'makes form with legend' do
    out = form(:method => :get){|f|
      f.legend('The Form')
    }
    assert(<<-FORM, out)
<form method="get">
  <fieldset>
    <legend>The Form</legend>
  </fieldset>
</form>
    FORM
  end

  ####################################################################
  ## input_text specs
  ####################################################################

  it 'makes form with input_text(label, name, value)' do
    out = form(:method => :get){|f|
      f.input_text 'Username', :username, 'mrfoo'
    }
    assert(<<-FORM, out)
<form method="get">
  <fieldset>
    <p>
      <label for="form-username" class="text_label">Username</label>
      <input type="text" name="username" class="text_input" id="form-username" value="mrfoo" />
    </p>
  </fieldset>
</form>
    FORM
  end

    it 'makes form with input_text(label, name, value) and no errors in encart' do
     out = form(:method => :get ){|f|
       f.input_text 'Username', :username, 'mrfoo'
     }
     #puts "\nGENERATED:\n#{out}"
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-username" class="text_label">Username</label>
       <input type="text" name="username" class="text_input" id="form-username" value="mrfoo" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with input_text(label, name)' do
     out = form(:method => :get){|f|
       f.input_text 'Username', :username
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-username" class="text_label">Username</label>
       <input type="text" name="username" class="text_input" id="form-username" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with input_text(label, name, value, hash)' do
     out = form(:method => :get){|f|
       f.input_text 'Username', :username, nil, :size => 10
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-username" class="text_label">Username</label>
       <input size="10" type="text" name="username" class="text_input" id="form-username" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
  it 'makes form with input_text(label, name, value, hash) specifiying class' do
     out = form(:method => :get){|f|
       f.input_text 'Username', :username, nil, :size => 10, :class=>'funky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-username" class="text_label">Username</label>
       <input size="10" type="text" name="username" class="funky" id="form-username" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with input_text(label, name, value, hash) specifiying class for input and label' do
     out = form(:method => :get){|f|
       f.input_text 'Username', :username, nil, :size => 10, :class=>'funky' , :class_label=>"echofunky"
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label class="echofunky" for="form-username">Username</label>
       <input type="text" class="funky" size="10" name="username" id="form-username" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   ####################################################################
   ## input_password specs
   ####################################################################
 
   it 'makes form with input_password(label, name)' do
     out = form(:method => :get){|f|
       f.input_password 'Password', :password
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-password" class="text_label">Password</label>
       <input type="password" name="password" class="text_input" id="form-password" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
    it 'makes form with input_password(label, name, hash) setting class' do
     out = form(:method => :get){|f|
       f.input_password 'Password', :password, :class=>'funky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-password" class="text_label">Password</label>
       <input type="password" name="password" class="funky" id="form-password" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
  it 'makes form with input_password(label, name, hash) setting class for input and label' do
     out = form(:method => :get){|f|
       f.input_password 'Password', :password, :class=>'funky' , :class_label => 'echofunky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-password" class="echofunky">Password</label>
       <input type="password" name="password" class="funky" id="form-password" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   ####################################################################
   ## input_submit specs
   ####################################################################
 
 
  it 'makes form with input_submit()' do
     out = form(:method => :get){|f|
       f.input_submit
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <input type="submit" class="button_submit" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with input_submit(value)' do
     out = form(:method => :get){|f|
       f.input_submit 'Send'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <input type="submit" class="button_submit" value="Send" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
    it 'makes form with input_submit(value, hash)' do
     out = form(:method => :get){|f|
       f.input_submit 'Send', :class=>'funky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <input type="submit" class="funky" value="Send" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
 
   ####################################################################
   ## input_checkbox specs
   ####################################################################
 
   it 'makes form with input_checkbox(label, name)' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-assigned" class="checkbox_label">Assigned</label>
       <input type="checkbox" name="assigned" class="checkbox_input" id="form-assigned" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
   it 'makes form with input_checkbox(label, name, nil, hash) setting class' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned, nil, :class=>'funky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-assigned" class="checkbox_label">Assigned</label>
       <input type="checkbox" name="assigned" class="funky" id="form-assigned" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with input_checkbox(label, name, nil, hash) setting class for input and label' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned, nil, :class=>'funky', :class_label => 'echofunky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-assigned" class="echofunky">Assigned</label>
       <input type="checkbox" name="assigned" class="funky" id="form-assigned" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
   
   it 'makes form with input_checkbox(label, name, checked = false)' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned, false
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-assigned" class="checkbox_label">Assigned</label>
       <input type="checkbox" name="assigned" class="checkbox_input" id="form-assigned" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
   it 'makes form with input_checkbox(label, name, checked = false, hash)' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned, false, :class=>'funky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-assigned" class="checkbox_label">Assigned</label>
       <input type="checkbox" name="assigned" class="funky" id="form-assigned" />
     </p>
   </fieldset>
 </form>
     FORM
   end          
 
   it 'makes form with input_checkbox(label, name, checked = true)' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned, true
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-assigned" class="checkbox_label">Assigned</label>
       <input type="checkbox" name="assigned" class="checkbox_input" id="form-assigned" checked="checked" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
   it 'makes form with input_checkbox(label, name, checked = true, hash)' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned, true, :class=>'funky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label class="checkbox_label" for="form-assigned">Assigned</label>
       <input checked="checked" type="checkbox" class="funky" name="assigned" id="form-assigned" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
   it 'makes form with input_checkbox(label, name, checked = nil)' do
     out = form(:method => :get){|f|
       f.input_checkbox 'Assigned', :assigned, nil
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-assigned" class="checkbox_label">Assigned</label>
       <input type="checkbox" name="assigned" class="checkbox_input" id="form-assigned" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   ####################################################################
   ## textarea specs
   ####################################################################
 
   it 'makes form with textarea(label, name)' do
     out = form(:method => :get){|f|
       f.textarea 'Message', :message
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-message" class="area_label">Message</label>
       <textarea name="message" id="form-message" class="area_input"></textarea>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with textarea(label, name, value)' do
     out = form(:method => :get){|f|
       f.textarea 'Message', :message, 'stuff'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-message" class="area_label">Message</label>
       <textarea name="message" id="form-message" class="area_input">stuff</textarea>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with textarea(label, name, value, hash) setting class' do
     out = form(:method => :get){|f|
       f.textarea 'Message', :message, 'stuff', :class=>'funky'
     }
   
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-message" class="area_label">Message</label>
       <textarea class="funky" name="message" id="form-message">stuff</textarea>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with textarea(label, name, value, hash) setting class for input and label' do
     out = form(:method => :get){|f|
       f.textarea 'Message', :message, 'stuff', :class=>'funky', :class_label => 'echofunky'
     }
 
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-message" class="echofunky">Message</label>
       <textarea class="funky" name="message" id="form-message">stuff</textarea>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   ####################################################################
   ## input_file specs
   ####################################################################
 
   it 'makes form with input_file(label, name)' do
     out = form(:method => :get){|f|
       f.input_file 'Avatar', :avatar
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-avatar" class="file_label">Avatar</label>
       <input type="file" name="avatar" class="file_input" id="form-avatar" />
     </p>
   </fieldset>
 </form>
     FORM
   end
           
           
  it 'makes form with input_file(label, name, hash) setting class' do
     out = form(:method => :get){|f|
       f.input_file 'Avatar', :avatar, :class=>'funky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-avatar" class="file_label">Avatar</label>
       <input type="file" name="avatar" class="funky" id="form-avatar" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
 
  it 'makes form with input_file(label, name, hash) setting class for field and label' do
     out = form(:method => :get){|f|
       f.input_file 'Avatar', :avatar, :class=>'funky', :class_label => 'echofunky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-avatar" class="echofunky">Avatar</label>
       <input type="file" name="avatar" class="funky" id="form-avatar" />
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   ####################################################################
   ## input_hidden specs
   ####################################################################
 
   it 'makes form with input_hidden(name)' do
     out = form(:method => :get){|f|
       f.input_hidden :post_id
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <input type="hidden" name="post_id" />
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with input_hidden(name, value)' do
     out = form(:method => :get){|f|
       f.input_hidden :post_id, 15
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <input type="hidden" name="post_id" value="15" />
   </fieldset>
 </form>
     FORM
   end
 

 
   ####################################################################
   ## select specs
   ####################################################################

     servers_hash = {
     :webrick => 'WEBrick',
     :mongrel => 'Mongrel',
     :thin => 'Thin',
   }

   it 'makes form with select(label, name, values) from hash' do
     out = form(:method => :get){|f|
       f.select 'Server', :server, servers_hash
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-server" class="select_label">Server</label>
       <select id="form-server" size="1" name="server">
         <option class="select_input" value="webrick">WEBrick</option>
         <option class="select_input" value="mongrel">Mongrel</option>
         <option class="select_input" value="thin">Thin</option>
       </select>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with select(label, name, values) with selection from hash' do
     out = form(:method => :get){|f|
       f.select 'Server', :server, servers_hash, :selected => :mongrel
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-server" class="select_label">Server</label>
       <select id="form-server" size="1" name="server">
         <option class="select_input" value="webrick">WEBrick</option>
         <option class="select_input" value="mongrel" selected="selected">Mongrel</option>
         <option class="select_input" value="thin">Thin</option>
       </select>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   servers_array = %w[ WEBrick Mongrel Thin]
 
   it 'makes form with select(label, name, values) from array' do
     out = form(:method => :get){|f|
       f.select 'Server', :server, servers_array
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-server" class="select_label">Server</label>
       <select id="form-server" size="1" name="server">
         <option class="select_input" value="WEBrick">WEBrick</option>
         <option class="select_input" value="Mongrel">Mongrel</option>
         <option class="select_input" value="Thin">Thin</option>
       </select>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   it 'makes form with select(label, name, values) with selection from array' do
     out = form(:method => :get){|f|
       f.select 'Server', :server, servers_array, :selected => 'Mongrel'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-server" class="select_label">Server</label>
       <select id="form-server" size="1" name="server">
         <option class="select_input" value="WEBrick">WEBrick</option>
         <option class="select_input" value="Mongrel" selected="selected">Mongrel</option>
         <option class="select_input" value="Thin">Thin</option>
       </select>
     </p>
   </fieldset>
 </form>
     FORM
   end


     it 'makes form with select(label, name, values) with selection from array and styling' do
     out = form(:method => :get){|f|
       f.select 'Server', :server, servers_array, :selected => 'Mongrel' , :class=>'funky' , :class_label=>'echofunky'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label for="form-server" class="echofunky">Server</label>
       <select id="form-server" size="1" name="server">
         <option class="funky" value="WEBrick">WEBrick</option>
         <option class="funky" value="Mongrel" selected="selected">Mongrel</option>
         <option class="funky" value="Thin">Thin</option>
       </select>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   ####################################################################
   ## radio specs
   ####################################################################
 
   it 'makes form with radio(label, name, values) with selection from array' do
     out = form(:method => :get){|f|
       f.radio 'Server', :server, servers_array, :checked => 'Mongrel'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <p>
       <label class="radio_label"  for="form-server-0"><input type="radio" class="radio_input" value="WEBrick" id="form-server-0" name="server" />WEBrick</label>
       <label class="radio_label"  for="form-server-1"><input type="radio" class="radio_input" value="Mongrel" id="form-server-1" name="server" checked="checked" />Mongrel</label>
       <label class="radio_label"  for="form-server-2"><input type="radio" class="radio_input" value="Thin"    id="form-server-2" name="server" />Thin</label>
     </p>
   </fieldset>
 </form>
     FORM
   end
 
   ####################################################################
   ## Error Handling : most of the BananaForm features are tested here
   ####################################################################

   ##
   ## Create a form containing text input fields,
   ## that will display the error summary
   ## and change the class of labels and fields to default values
   ##
   it 'creates form with error summary, default styling' do
     form_error :username, 'invalid username'
     out = form(:method => :get){|f|
        f.input_text 'Username', :username
     }
     assert(<<-FORM, out)
 <form method="get">
       <div class="form_error_summary" id="form_error_summary">
             <h2>1 error(s) prohibited this form from being saved</h2>
             <p>Following fields reported errors:</p>
             <ul>
                 <li>username : invalid username</li>
             </ul>
       </div>
       <fieldset>
         <p>
           <label class="text_label_error" for="form-username">Username</label>
           <input type="text" class="text_input_error" name="username" id="form-username" />
         </p>
       </fieldset>
 </form>
 FORM
   end
   ## Same as previous using radio buttons fields
   it 'creates form with radio(label, name, values) with selection and error summary' do
     form_error :server, 'invalid server'
     out = form(:method => :get ){|f|
       f.radio 'Server', :server, servers_array, :checked => 'Mongrel'
     }
     assert(<<-FORM, out)
 <form method="get">
   <fieldset>
     <div class="form_error_summary" id="form_error_summary">
       <h2>1 error(s) prohibited this form from being saved</h2>
       <p>Following fields reported errors:</p>
       <ul><li>server : invalid server</li></ul>
     </div>
     <p>
       <label class="radio_label" for="form-server-0"><input type="radio" class="radio_input" value="WEBrick" name="server" id="form-server-0" />WEBrick</label>
       <label class="radio_label" for="form-server-1"><input type="radio" checked="checked" class="radio_input_error" value="Mongrel" name="server" id="form-server-1" />Mongrel</label>
       <label class="radio_label" for="form-server-2"><input type="radio" class="radio_input" value="Thin" name="server" id="form-server-2" />Thin</label>
     </p>
   </fieldset>
 </form>
     FORM
   end

   ##
   ## Create a form containing text input fields,
   ## that will display the error summary with options
   ## and change the class of labels and fields to default values
   ##
   it 'creates form with error sumary, options provided' do
     form_error :username, 'invalid username'
     #error_encart_content
     out = form(:method => :get, 
                :error_summary_id=>'funky_id',
                :error_summary_class => 'funky_class',
                :error_summary_title => 'Funky title',
                :error_summary_subtitle => 'Funky Subtitle') {|f|
                
        f.input_text 'Username', :username
     }
     #puts "GOT :\n#{out}\n"
     assert(<<-FORM, out)
 <form method="get">
       <div class="funky_class" id="funky_id">
             <h2>Funky title</h2>
             <p>Funky Subtitle</p>
             <ul>
                 <li>username : invalid username</li>
             </ul>
       </div>
       <fieldset>
         <p>
           <label for="form-username" class="text_label_error">Username</label>
           <input type="text" class="text_input_error" name="username" id="form-username" />
         </p>
       </fieldset>
 </form>
 FORM
   end

   ## Create a form containing an error summary where both summary and
   ## css style classes are provided
   it 'creates form with error summary, options provided for summary,label and field' do
     form_error :username, 'invalid username'
     #error_encart_content
     out = form(:method => :get,
                :error_summary_id=>'funky_id',
                :error_summary_class => 'funky_class',
                :error_summary_title => 'Funky title',
                :error_summary_subtitle => 'Funky Subtitle') {|f|
 
        f.input_text 'Username', :username, nil, :class=>'funky',:class_label => 'echofunky'
     }
     assert(<<-FORM, out)
 <form method="get">
       <div class="funky_class" id="funky_id">
             <h2>Funky title</h2>
             <p>Funky Subtitle</p>
             <ul>
                 <li>username : invalid username</li>
             </ul>
       </div>
       <fieldset>
         <p>
           <label class="echofunky_error" for="form-username">Username</label>
           <input class="funky_error" type="text" name="username" id="form-username" />
         </p>
       </fieldset>
 </form>
 FORM
   end

   ## Create a form containing an error summary where all is parametered
  it 'creates form with error summary, options provided for summary,label and field full override' do
     form_error :username, 'invalid username'
     #error_encart_content
     out = form(:method => :get,
                :error_summary_id=>'funky_id',
                :error_summary_class => 'funky_class',
                :error_summary_title => 'Funky title',
                :error_summary_subtitle => 'Funky Subtitle') {|f|
 
        f.input_text('Username',
                     :username, nil,
                     :class=>'funky',
                     :class_error => 'tagada',
                     :class_label=>'echofunky',
                     :class_label_error=>'echo_pfunk')
     }
     assert(<<-FORM, out)
 <form method="get">
       <div class="funky_class" id="funky_id">
             <h2>Funky title</h2>
             <p>Funky Subtitle</p>
             <ul>
                 <li>username : invalid username</li>
             </ul>
       </div>
       <fieldset>
         <p>
           <label class="echo_pfunk" for="form-username">Username</label>
           <input type="text" class="tagada" name="username" id="form-username" />
         </p>
       </fieldset>
 </form>
 FORM
   end

end
