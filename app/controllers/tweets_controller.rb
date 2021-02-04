class TweetsController < ApplicationController


    get '/tweets/new' do
        if logged_in?
            erb :'tweets/new'
        else
            redirect to '/login'
        end
    end

    get '/tweets' do
        if logged_in?
            @user = current_user
            erb :'tweets/tweets'
        else
            redirect to '/login'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            @user = User.find_by_id(@tweet.user_id)
            erb :'/tweets/show_tweet'
        else
            redirect to '/login'
        end
    end

    get '/tweets/:id/edit' do 
        @tweet = Tweet.find_by_id(params[:id])
        if logged_in?
            if current_user == @tweet.user
                erb :'tweets/edit'
            else
                redirect to '/tweets'
            end
        else
            redirect to '/login'
        end
    end

    post '/tweets' do 
        if logged_in?
            if params[:content] == ""
                redirect to '/tweets/new'
            else
                @user = current_user
                @tweet = Tweet.create(content: params[:content], user_id: @user.id)
                @user.tweets << @tweet
                redirect to "/tweets/#{@tweet.id}"
            end
        else
            redirect to '/login'
        end
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find_by_id(params[:id])
        if params[:content] == ""
            redirect to "/tweets/#{@tweet.id}/edit"
        else
            @tweet.update(content: params[:content])
            @tweet.save
            redirect to "/tweets/#{@tweet.id}"
        end
    end

    delete '/tweets/:id' do
        tweet = Tweet.find_by_id(params[:id])
        if logged_in?
            if current_user.id == tweet.user_id
                tweet.delete
            else
                redirect to '/tweets'
            end
        else
            redirect to '/login'
        end
    end

end
