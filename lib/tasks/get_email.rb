# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'mail'
if false
Mail.defaults do
  retriever_method :pop3, :address    => "pop.gmail.com",
                          :port       => 995,
                          :user_name  => 'w090.001',
                          :password   => '11102008',
                          :enable_ssl => true
end

#emails = Mail.find(:what => :first, :count => 10, :order => :asc)
#puts emails.length #=> 10

Mail.all.each  do |mail|
 puts mail
 puts mail.subject
 puts mail.body
end
end

Mail.defaults do
  retriever_method :pop3, :address    => "pop.163.com",
                          :port       => 995,
                          :user_name  => 'w090_001@163.com',
                          :password   => 'followme123#',
                          :enable_ssl => true
end

unread_mail=Mail.first
unless unread_mail.blank?
puts unread_mail.subject
unread_mail=Mail.first
end