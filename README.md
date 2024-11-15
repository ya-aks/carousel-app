# carousel-app
This App has a carousel view that can be added in any view or viewcontroller, it adapts the parent view

Components:

CarouselView
    - This is a generic Carousel View, which lays out the views passed to it in a carousel form with page indicator as well.
    - Number of views are generic, it can handle as much views you need, you just have to send an array of views
    - This takes a configuration as input as well otherwise uses default configuration
        -   Configuration has three properties
            -   maxItemSize: This will be the maxSize of a carousel view you want, you can configure it as per your need default is 250
            -   scaleFactor: This is a the factor to which scale the center view (adjust it to make the center view big or small with respect to other views)
            -   defaultIndex: This is the index which has to be shown by default when Carousel is created (you can configure as per your needs if not sent the middle view will always be shown in center)
CarouselCardView
    - This is card view which is to be used it carousel, right now it just has an image support, but it can be changes individual to support new requirements on the card as well.
CarouselViewController
    - This is a view controller to show the usage of card view, that you can add the carousel view to any view or viewcontroller and it will work.
    

Models:

CarouselImage
    - This is the model for an image to be used in carousel
    - Supports both the assets using name as well as url right now
    
CarouselCardModel
    - This is for storing data related to Carousel Card which right now just has Carousel Image but can be updated individually with new fields.



https://github.com/user-attachments/assets/bcc7468e-753c-4194-9236-5e3dcedd93f2





