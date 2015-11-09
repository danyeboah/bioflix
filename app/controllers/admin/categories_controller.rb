class Admin::CategoriesController < AdminsController
  before_action :find_category, only:[:destroy,:edit,:update]

  def new
    @category = Category.new
    @all_categories = Category.all
  end

  def create
    category = Category.new(category_params)
    if category.save
      flash["success"] = "Category has been added"
    else
      flash["danger"] = "There was a problem adding that category"
    end
    redirect_to new_admin_category_path
  end

  def destroy
    @category.destroy
    redirect_to new_admin_category_path
  end

  def edit;end

  def update
    if @category.update(category_params)
      flash["success"] = "Category was successfully edited"
      redirect_to new_admin_category_path
    else
      flash.now["danger"] = "There was a problem updating this category"
      render 
    end

  end


  private
  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(slug: params[:id])
  end

end