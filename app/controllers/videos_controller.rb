class VideosController < ApplicationController
  before_filter :signed_in_user, only: [:index, :create, :edit, :new]
  
  respond_to :html, :js, only: [:update, :index, :destroy]
  
  respond_to :html, :json, only: [:show]
  
  def new
    @user = current_user
    @video = Video.new(user_id: @user.id)
  rescue
    flash[:error] = "Unable to add video."
    redirect_to :back
  end
  
  def addvideo
    redirect_to watch_path
    # if signed_in?
    #   @people = %w[0003EF 0007GY 0009PO 0011H0 0012GN 0013MR 0013T0 0014TE 0016XY 0019NQ 0020NK 0020XN 00229P 0023T6 0024H4 0025UT 00310N 0031A2 0032QT 0032RL 0032RY 00335Z 00339B 0033GX 0034C0 0034Y2 00358U 0041LQ 0044DE 00469Z 0046CN 00530S 00606W 00628E 0066QU 0067MJ 0151CF 0156A6 0160X0 0167NX 1058RC 1059H7 1061M9 1090V3]
    #   @dogs = %w[001368 0013Y3 0016R6 0018H9 0019J9 0022D3 0025UE 0027XZ 002976 0030ZM 0035QA 0036GR 0037DV 0042AY 0046Y0 0047HG 004813 0049U5 0050T6 0052GP 0053YU 00541F 0145F8 0146Q1 01542R 01550J 0162UN 0163W7 0164LR 10528P 1063QQ 1075ZH 10762C 10779G 107810 1081A9 10829U 1084LI 1086M3 1088AT 1089YC 1111KT]
    #   @cats = %w[00041Y 00045L 0004NJ 0004NP 0005RA 0005RK 0005RO 0005UC 0006EG 0006O2 0007DP 0007EH 00088N 0009T1 00106Q 0010UJ 0012E3 0014XU 0015DV 0015NQ 0016BN 00178F 0018K1 00207K 0024R1 00251Z 0026JC 0028UK 00295A 0030RJ 0030RO 0031GC 0032J8 0033FX 0034C3 004018 0041ZH 0042FL 00431X 0043KB 0044RD 004501 0045WI]
    #   @misc = %w[0002Y5 00035C 0004NZ 00068O 0006JC 0007M7 0008FD 0010V7 00110T 0011YS 00222K 002245 0022FQ 00235B 0023GB 0024P6 0025CE 0026NW 002703 00273K 0028LT 0029TY 0034ID 0037OU 003991 0042PG 01615S]
    #   @going_home = %w[0002GM 0004OA 00173E 00186Y 00190U 00204N 00216J 00243E 002556 0029IF 00638P 01663Y 1049OS 1050KA 1051FX 1073AN 1074UK 1083FR 1109KC 11107C 11143L 1115W0 1118Z5 1120HN]
    # else
    #   flash[:notice] = "You must be signed in to access this page."
    #   redirect_to signin_path
    # end
  end
  
  def create
    @user = current_user
    @video = Video.create!(params[:video])
    if @video.save
      flash[:notice] = "Your video entitled '#{@video.title}' was added."
      # add email notice to Steven
      VideoMailer.new_video(@video,current_user).deliver
    else
      flash[:notice] = "Upload of video failed."
    end
    redirect_to myvideos_path
  rescue
    flash[:error] = "Unable to add your video."
    redirect_to addvideo_path
  end
  
  def update
    @video = Video.find(params[:id])
    if @video.update_attributes(params[:video])
      # if video approved, send email to user
      unless cookies[:editTitle] == "true" || @video.approved == false
        VideoMailer.approved_video(@video).deliver
      end
      redirect_to :back
      cookies[:editTitle] = "false"
    end
  rescue
    if @video
      flash[:error] = "Unable to update #{@video.title}."
    else
      flash[:error] = "Unable to update video."
    end
    redirect_to :back
  end
  
  def show
    @video = Video.find(params[:id])
    @vote_check = Vote.where(video_id: @video.id, user_id: current_user.id).last if signed_in?
    respond_with do |format|
      format.json { render :json => @video }
    end
    flash[:notice] = "<p>You do not need to create an account to watch or share a video, but you must be signed 
                      in to vote for a video.</p><p>You may vote for a video once every 24 hours.</p>".html_safe
  end
  
  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    Panda::Video.delete(@video.panda_video_id)
    flash[:notice] = "'#{@video.title}' deleted."
    redirect_to :back
  rescue
    if @video
      flash[:error] = "Unable to delete #{@video.title}."
    else
      flash[:error] = "Unable to delete video."
    end
    redirect_to :back
  end
  
  def index
    if current_user.admin?
      @videos = Video.includes(:category, :user).search(params[:search])
      cookies[:video_count] = @videos.length
      @videos = @videos.paginate(page: params[:page], per_page: 12)
    else
      redirect_to root_path
    end
  rescue
    flash[:error] = "Unable to display pet videos."
    redirect_to root_path
  end
  
  def watch
    @videos = Video.where(approved: true).includes(:category, :user)
    seed = Random.rand()
    if seed > 0.5
      @videos.reorder("title ASC")
    else
      @videos.reorder("votes_count ASC")
    end
    # @new_videos = Video.where(created_at: 7.days.ago.utc...Time.now.utc, approved: true).includes(:category, :user)
    @rated_videos = []#Video.rated
    @voted_videos = Video.where(id: (Vote.all.map{|p| p.video_id}.uniq), approved: true).includes(:category, :user).reorder("votes_count DESC").first(12)
    @played_videos = Video.where(id: (Play.all.map{|p| p.video_id}.uniq), approved: true).includes(:category, :user).reorder("plays_count DESC").first(12)
    @shared_videos = Video.where(id: (Share.all.map{|p| p.video_id}.uniq), approved: true).includes(:category, :user).reorder("shares_count DESC").first(12)
    @videos_count = @videos.length
    # @new_videos_count = @new_videos.length
    # @rated_videos_count = @rated_videos.length
    # @voted_videos_count = @voted_videos.length
    # @played_videos_count = @played_videos.length
    # @shared_videos_count = @shared_videos.length
    @videos = @videos.paginate(page: params[:all_videos], per_page: 12)
    # @new_videos = @new_videos.paginate(page: params[:new_videos], per_page: 12)
    @rated_videos = []#@rated_videos.paginate(page: params[:rated_videos], per_page: 12)
    @voted_videos = @voted_videos #.paginate(page: params[:voted_videos], per_page: 12)
    @played_videos = @played_videos #.paginate(page: params[:played_videos], per_page: 12)
    @shared_videos = @shared_videos #.paginate(page: params[:shared_videos], per_page: 12)
    flash[:notice] = "<p>You do not need to create an account to watch or share a video, but you must be signed 
                      in to vote for a video.</p><p>You may vote for a video once every 24 hours.</p>".html_safe
  end
end
