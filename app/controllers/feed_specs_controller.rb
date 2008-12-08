class FeedSpecsController < ApplicationController
  # GET /feed_specs
  # GET /feed_specs.xml
  def index
    @feed_specs = FeedSpec.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feed_specs }
    end
  end

  # GET /feed_specs/1
  # GET /feed_specs/1.xml
  def show
    @feed_spec = FeedSpec.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed_spec }
    end
  end

  # GET /feed_specs/new
  # GET /feed_specs/new.xml
  def new
    @feed_spec = FeedSpec.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed_spec }
    end
  end

  # GET /feed_specs/1/edit
  def edit
    @feed_spec = FeedSpec.find(params[:id])
  end

  # POST /feed_specs
  # POST /feed_specs.xml
  def create
    @feed_spec = FeedSpec.new(params[:feed_spec])

    respond_to do |format|
      if @feed_spec.save
        flash[:notice] = 'FeedSpec was successfully created.'
        format.html { redirect_to(@feed_spec) }
        format.xml  { render :xml => @feed_spec, :status => :created, :location => @feed_spec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed_spec.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feed_specs/1
  # PUT /feed_specs/1.xml
  def update
    @feed_spec = FeedSpec.find(params[:id])

    respond_to do |format|
      if @feed_spec.update_attributes(params[:feed_spec])
        flash[:notice] = 'FeedSpec was successfully updated.'
        format.html { redirect_to(@feed_spec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed_spec.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_specs/1
  # DELETE /feed_specs/1.xml
  def destroy
    @feed_spec = FeedSpec.find(params[:id])
    @feed_spec.destroy

    respond_to do |format|
      format.html { redirect_to(feed_specs_url) }
      format.xml  { head :ok }
    end
  end
end
