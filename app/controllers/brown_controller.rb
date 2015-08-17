class BrownController < ApplicationController
require_relative 'support_sort' #sort_by_frequency 메소드를 받습니다

# before_filter :authenticate_user!,
#     :only => [:main]
  
  def main
    @hash = Campushash.all
    @bunny = "fat"
    @posts = Post.all
    
    if !current_user.nil?
      userhash = Userhashrel.where("user_id = ?", current_user.id)
      @usermango = []
      @usermelon = []
      
      userhash.each do |usershash|
        if usershash.pick_type == 0
          @usermango << usershash.campushash_id
        elsif usershash.pick_type == 1
          @usermelon << usershash.campushash_id
        end
     end
          
    end
    @topfive = Userhashrel.select('campushash_id, count(campushash_id) as frequency').order('frequency desc').group('campushash_id').take(10) #선호해쉬태그 노출
    
  end
  
  def search 
  
  end
  
  def post_new     #p는 이름짓기 귀찮아서 선언한 변수명입니다 문제가 있으면 아무렇게나 바꿀 수 있습니다
    due_date = params[:deadline]
    input_hash = params[:hash].split(' ')
    p = Post.new
    p.post_image = params[:imageurl]
    p.post_category = params[:category]
    p.post_company = params[:company]
    p.post_subject = params[:subject]
    p.post_deadline = due_date["date"]
    p.post_content = params[:content]
    p.save
    
    input_hash.each do |hash|
      Campushash.find_or_create_by(hash_content: hash)
      
    end
    
    input_hash.each do |hash|
      post_hash_rel = Posthashrel.new
      post_hash_rel.post_id = p.id
      post_hash_rel.campushash_id = Campushash.find_by(hash_content: hash).id
      post_hash_rel.save
    end
    
    
    redirect_to '/brown/newpost'
    
    
  end

  def post_list
    @posts = Post.all
    
    if !params[:id].nil?    
    p = Post.find(params[:id])
    p.destroy
    redirect_to '/brown/post_list'
    end
          
  end
  
  def pickhash
    #해쉬를 받아와서 type을 바꾸는 연산을 합니다
    hashinput = params[:id].to_i
    pick = Userhashrel.where("user_id= ? and campushash_id= ?", current_user.id, hashinput).take
        
    
    #post의 우선순위를 위한 mango melon 점수 부여    
    if pick.nil?
    
      picked_hash = Userhashrel.new
      picked_hash.user_id = current_user.id
      picked_hash.campushash_id = hashinput
      picked_hash.pick_type = 0
      picked_hash.save
            
      elsif pick.pick_type == 0               #원래 망고인 것이 들어오면 1 더해줌
        pick.pick_type = pick.pick_type + 1
        pick.save
        
        
      else pick.pick_type  > 0                #원래 멜론이 들어오면 
          pick.destroy

    end
    
    
    posthasit = Posthashrel.where("campushash_id=?", hashinput).pluck(:post_id) #해당 해쉬를 가진 post들을 모읍니다
    userhasmango = Userhashrel.where("user_id=? and pick_type = ?", current_user.id, 0).pluck(:campushash_id) # 유저가 가진 망고해쉬태그값들을 모읍니다
    userhasmelon = Userhashrel.where("user_id=? and pick_type = ?", current_user.id, 1).pluck(:campushash_id) # 유저가 가진 메론해쉬태그값들을 모읍니다
    
    posthasit.each do |x|   #해당 post가 가진 모든 hashtag와 user가 가진 hastag를 비교해서 망고멜론 점수를 매기는 연산
      
      inthepost = Posthashrel.where("post_id=?",x).pluck(:campushash_id) #입력한 해쉬를 가진 포스트가 가진 해쉬를 배열화합니다
      p = Postuserrel.where("post_id=? and user_id=?",x,current_user.id).first_or_create  #포스트와 유저의 관계 참조 테이블을 찾거나 만듭니다
      p.post_id = x
      p.user_id = current_user.id
      p.mango = (inthepost & userhasmango).size #해당 참조 테이블에 망고멜론 점수를 넣어주고 저장합니다
      p.melon = (inthepost & userhasmelon).size
      p.save
      
    end
    
    redirect_to '/'
    
  end
  
  def user_hash 
    @hash = Campushash.all
    userhash = Userhashrel.where("user_id = ?", current_user.id)
    @usermango = []
    @usermelon = []
    userhash.each do |usershash|
      if usershash.pick_type == 0
        @usermango << usershash.campushash_id
      elsif usershash.pick_type == 1
        @usermelon << usershash.campushash_id
      end
    end  
  
  
  @pophash = Userhashrel.select('campushash_id, count(campushash_id) as frequency').order('frequency desc').group('campushash_id').take(10) #선호해쉬태그 노출
  
  #큐레이션시작
  curation = []
  
  current_user.userhashrels.each do |who_hash|
      who_hash.campushash.userhashrels.each do |has_users|
        curation = curation + has_users.user.userhashrels.pluck(:campushash_id)  
      end
  end
  
  
  
  @curation = curation.sort_by_frequency.reverse.uniq-current_user.userhashrels.pluck(:campushash_id)
  
  
  end
  
  def hash_list
    @hashs = Campushash.all
    if !params[:id].nil?
      p = Campushash.find(params[:id].to_i)
      p.destroy
      redirect_to :back
    end
    
    
  end
  
  def tagpost
    post_id = params[:id].to_i
    tag_type = params[:tagtype].to_i
    pickpost = Postuserrel.where("post_id=? and user_id=?",post_id,current_user).take
    if pickpost.nil?
      pickpost = Postuserrel.new
    end
    pickpost.user_id = current_user.id
    pickpost.post_id = post_id
    pickpost.tag = tag_type
    pickpost.save
    redirect_to :back
  end
  
  
  def calendar
    @picked_post=current_user.postuserrels.where("tag=?",2)
    
    
  end
  
  def hash_update
    hash_id = params[:id].to_i
    hash_cate = params[:cates]
    p = Campushash.find(hash_id)
    p.hash_category = hash_cate
    p.save
    redirect_to :back
  end
  
end
