# DiagnalAssessmentTest

Movie Listing Screen

MovieListingVC

Features:
- Movie Listing: Browse through a curated list of movies with seamless pagination. As you scroll to the bottom of the list, more data is loaded automatically, ensuring you can keep exploring without interruption.

- Search Functionality: Easily search for movies within the loaded data. Our search feature ensures that you can quickly find the movie you're looking for.

- Handling Long Movie Titles: Don't worry about lengthy movie names. We've implemented a marquee text feature that displays the full name of movies with an animated text effect. You'll never miss out on the details, even with extended titles.



MovieViewModel

Data Management:
- Data Source: The MovieViewModel handles data retrieval from JSON files and prepares it for display in the MovieListingVC.

- Communication: To ensure smooth communication between the ViewModel and the MovieListingVC, we utilize closures. Here's how it works: The MovieListingVC has an instance of the ViewModel and requests movie data. The ViewModel loads the data from the JSON file and passes it back to the controller using a closure. When the data is received through the closure, it signals to the MovieListingVC that the requested data is ready for presentation.




MovieListingResponse Model (Data Model)

- Data Organization: The MovieListingResponse model plays a crucial role in structuring the data received from our requests. It organizes the JSON data into a format that is easy to work with and present to the user.
- JSON Serialization: The process of converting JSON data into our structured data model is referred to as JSON serialization. This essential step ensures that we can efficiently populate our user interface with relevant information.

Thank you for exploring our movie listing screen. If you have any questions or need further information, please feel free to reach out.🍿🎥🎬
