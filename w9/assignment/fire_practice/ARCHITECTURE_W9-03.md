# W9-03 Architecture Documentation: Join Song with Artist

## Implementation Approach

**Selected Approach**: ViewModel Layer Join (Approach 2)

## Architecture Overview

The solution joins Song and Artist data at the ViewModel layer, creating enriched `SongWithArtist` objects for display in the UI.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                            UI LAYER                                  │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ LibraryScreen                                                  │ │
│  │  - Provides LibraryViewModel via ChangeNotifierProvider        │ │
│  │  - Injects SongRepository, ArtistRepository, PlayerState       │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                  │                                   │
│  ┌────────────────────────────────▼────────────────────────────────┐ │
│  │ LibraryContent                                                  │ │
│  │  - Watches LibraryViewModel                                    │ │
│  │  - Handles AsyncValue states (loading/error/success)           │ │
│  │  - Renders ListView.builder with SongTile widgets              │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                  │                                   │
│  ┌────────────────────────────────▼────────────────────────────────┐ │
│  │ SongTile                                                        │ │
│  │  - Displays SongWithArtist data                                │ │
│  │  - Shows artist image, song title, artist name & genre         │ │
│  │  - Shows "Playing" indicator when active                       │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────▼───────────────────────────────────┐
│                         VIEWMODEL LAYER                              │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ LibraryViewModel                                               │ │
│  │  - Dependencies: SongRepository, ArtistRepository, PlayerState │ │
│  │  - State: AsyncValue<List<SongWithArtist>> songsValue          │ │
│  │                                                                │ │
│  │  fetchSong():                                                  │ │
│  │    1. Fetch songs and artists in parallel (Future.wait)        │ │
│  │    2. Create Map<String, Artist> for O(1) lookup               │ │
│  │    3. Join: song.artistId → Artist object                      │ │
│  │    4. Create SongWithArtist using factory constructor          │ │
│  │    5. Handle missing artists with fallback                     │ │
│  │                                                                │ │
│  │  isSongPlaying(SongWithArtist): bool                           │ │
│  │  start(SongWithArtist): void                                   │ │
│  │  stop(SongWithArtist): void                                    │ │
│  └────────────────────────────────────────────────────────────────┘ │
└───────────────────────┬────────────────────────┬────────────────────┘
                        │                        │
┌───────────────────────▼────────┐   ┌───────────▼────────────────────┐
│     REPOSITORY LAYER            │   │   REPOSITORY LAYER             │
│  ┌──────────────────────────┐  │   │  ┌──────────────────────────┐ │
│  │ SongRepository           │  │   │  │ ArtistRepository         │ │
│  │  - fetchSongs()          │  │   │  │  - fetchArtists()        │ │
│  │  - fetchSongById()       │  │   │  └──────────────────────────┘ │
│  └──────────────────────────┘  │   │              │                 │
│              │                  │   │  ┌──────────▼────────────────┐ │
│  ┌───────────▼───────────────┐ │   │  │ ArtistRepositoryFirebase  │ │
│  │ SongRepositoryFirebase    │ │   │  │  - HTTP GET               │ │
│  │  - HTTP GET               │ │   │  │  - /week9/artists.json    │ │
│  │  - /week9/songs.json      │ │   │  │  - ArtistDto.fromJson()   │ │
│  │  - SongDto.fromJson()     │ │   │  └───────────────────────────┘ │
│  └───────────────────────────┘ │   └────────────────────────────────┘
└─────────────────────────────────┘
                        │                        │
┌───────────────────────▼────────────────────────▼────────────────────┐
│                         DATA LAYER                                   │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ SongWithArtist Model                                           │ │
│  │  - Enriched model with flattened artist data                   │ │
│  │  - Fields: id, title, duration, songImageUrl                   │ │
│  │           artistId, artistName, artistGenre, artistImageUrl    │ │
│  │  - Factory: SongWithArtist.fromSongAndArtist(Song, Artist)     │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────▼───────────────────────────────────┐
│                      FIREBASE REALTIME DATABASE                      │
│  /week9/songs.json       {songId → {artistId, title, duration...}}  │
│  /week9/artists.json     {artistId → {name, genre, imageUrl...}}    │
└─────────────────────────────────────────────────────────────────────┘
```

## Sequence Diagram

```
┌────┐  ┌──────────┐  ┌─────────────┐  ┌────────────┐  ┌──────────────┐  ┌────────┐
│User│  │LibraryUI │  │LibraryViewModel SongRepo   │  │ ArtistRepo   │  │Firebase│
└─┬──┘  └────┬─────┘  └──────┬──────┘  └─────┬──────┘  └──────┬───────┘  └───┬────┘
  │          │               │               │                │              │
  │ Open Library             │               │                │              │
  ├─────────►│               │               │                │              │
  │          │               │               │                │              │
  │          │ watch()       │               │                │              │
  │          ├──────────────►│               │                │              │
  │          │               │               │                │              │
  │          │               │ fetchSong()   │                │              │
  │          │               ├───┐           │                │              │
  │          │               │   │ Set loading                │              │
  │          │               │◄──┘           │                │              │
  │          │               │               │                │              │
  │          │ Loading State │               │                │              │
  │          │◄──────────────┤               │                │              │
  │          │               │               │                │              │
  │  Show Loading            │               │                │              │
  │◄─────────┤               │               │                │              │
  │          │               │               │                │              │
  │          │               │ Future.wait([                  │              │
  │          │               │  fetchSongs(),                 │              │
  │          │               │  fetchArtists()                │              │
  │          │               │ ])            │                │              │
  │          │               │               │                │              │
  │          │               │ fetchSongs()  │                │              │
  │          │               ├──────────────►│                │              │
  │          │               │               │                │              │
  │          │               │               │ GET /songs.json               │
  │          │               │               ├───────────────────────────────►
  │          │               │               │                │              │
  │          │               │               │ {song_1: {...}, song_2: {...}}
  │          │               │               │◄───────────────────────────────┤
  │          │               │               │                │              │
  │          │               │ List<Song>    │                │              │
  │          │               │◄──────────────┤                │              │
  │          │               │               │                │              │
  │          │               │ fetchArtists()│                │              │
  │          │               ├───────────────────────────────►│              │
  │          │               │               │                │              │
  │          │               │               │                │ GET /artists │
  │          │               │               │                ├─────────────►│
  │          │               │               │                │              │
  │          │               │               │   {artist_1: {...}, artist_2..}
  │          │               │               │                │◄─────────────┤
  │          │               │               │                │              │
  │          │               │ List<Artist>  │                │              │
  │          │               │◄───────────────────────────────┤              │
  │          │               │               │                │              │
  │          │               │ Join Data     │                │              │
  │          │               ├───┐           │                │              │
  │          │               │   │ 1. Build Map<artistId, Artist>           │
  │          │               │   │ 2. For each song:                        │
  │          │               │   │    - Lookup artist by song.artistId      │
  │          │               │   │    - Create SongWithArtist               │
  │          │               │   │ 3. Handle missing artists (fallback)     │
  │          │               │◄──┘           │                │              │
  │          │               │               │                │              │
  │          │               │ Set success   │                │              │
  │          │               │ state         │                │              │
  │          │               ├───┐           │                │              │
  │          │               │   │ songsValue = AsyncValue.success(...)     │
  │          │               │◄──┘           │                │              │
  │          │               │               │                │              │
  │          │ Success State │               │                │              │
  │          │ List<SongWith │               │                │              │
  │          │      Artist>  │               │                │              │
  │          │◄──────────────┤               │                │              │
  │          │               │               │                │              │
  │  Display Songs with      │               │                │              │
  │  Artist Info             │               │                │              │
  │  - Artist image          │               │                │              │
  │  - Song title            │               │                │              │
  │  - Artist name           │               │                │              │
  │  - Artist genre          │               │                │              │
  │◄─────────┤               │               │                │              │
  │          │               │               │                │              │
  │ Tap Song │               │               │                │              │
  ├─────────►│               │               │                │              │
  │          │               │               │                │              │
  │          │ start(song)   │               │                │              │
  │          ├──────────────►│               │                │              │
  │          │               │               │                │              │
  │          │               │ Convert to Song for PlayerState               │
  │          │               │ playerState.start(song)        │              │
  │          │               ├───┐           │                │              │
  │          │               │◄──┘           │                │              │
  │          │               │               │                │              │
  │          │ Update UI     │               │                │              │
  │          │ (show Playing)│               │                │              │
  │          │◄──────────────┤               │                │              │
  │          │               │               │                │              │
  │  Show "Playing"          │               │                │              │
  │◄─────────┤               │                │               │              │
  │          │               │               │                │              │
```

## Data Model

### SongWithArtist

```dart
class SongWithArtist {
  final String id;              // Song ID
  final String title;           // Song title
  final Duration duration;      // Song duration
  final Uri songImageUrl;       // Song cover image
  final String artistId;        // Artist ID (for reference)
  final String artistName;      // Artist name (denormalized)
  final String artistGenre;     // Artist genre (denormalized)
  final Uri artistImageUrl;     // Artist profile image (denormalized)
}
```

**Design Decision**: Flattened structure (denormalized) for:
- Simpler UI access (no nested object navigation)
- Better performance (no additional lookups in UI layer)
- Type safety at compile time

## Answers to Questions

### ❓ Where do you want to join the song and the artist collections?

**Answer**: **ViewModel Layer** (`LibraryViewModel`)

**Reasoning**:
- ViewModel layer handles business logic and data transformation
- Keeps repositories focused on single data source operations
- Join logic is encapsulated in one place
- UI components receive ready-to-display data

### ❓ How do you want to store the Song additional information (artist name, artist genre...)?

**Answer**: **Flattened model** (`SongWithArtist`)

**Storage Strategy**:
- Create a new `SongWithArtist` model with denormalized artist properties
- Artist data is flattened into the song object
- No nested `Artist` object reference
- All fields are typed and immutable

**Benefits**:
1. **Simplicity**: UI code accesses `song.artistName` directly
2. **Performance**: No runtime lookups or null checks in UI rendering
3. **Type Safety**: Compile-time guarantees for all properties
4. **Maintainability**: Clear data contract between ViewModel and UI

## Join Algorithm

The join operation uses a **hash-based join** for optimal performance:

```dart
// 1. Fetch both datasets in parallel
final results = await Future.wait([
  songRepository.fetchSongs(),
  artistRepository.fetchArtists(),
]);

// 2. Build hash map for O(1) lookups
Map<String, Artist> artistMap = {
  for (var artist in artists) artist.id: artist
};

// 3. Join with fallback for missing artists
List<SongWithArtist> songsWithArtists = songs.map((song) {
  Artist? artist = artistMap[song.artist];  // O(1) lookup
  if (artist == null) {
    // Graceful degradation
    artist = Artist(id: song.artist, name: 'Unknown Artist', ...);
  }
  return SongWithArtist.fromSongAndArtist(song, artist);
}).toList();
```

**Time Complexity**: O(n + m) where n = songs, m = artists
**Space Complexity**: O(m) for the artist map

## Benefits of This Approach

1. **Clean Separation**: ViewModel handles data aggregation, UI handles presentation
2. **Parallel Fetching**: Songs and artists loaded simultaneously for better performance
3. **Error Resilience**: Graceful handling of missing artist data
4. **Type Safety**: Strong typing throughout the data flow
5. **Testability**: Easy to mock repositories and test join logic
6. **Simplicity**: No service layer overhead for this specific use case

## Trade-offs

### Advantages ✅
- Simple implementation with minimal new code
- ViewModel controls the business logic
- No new architectural layers needed
- Easy to understand and maintain

### Disadvantages ❌
- ViewModel has more responsibilities (data fetching + joining)
- Harder to reuse join logic if needed elsewhere
- Less scalable for complex multi-entity joins

## Future Enhancements

If the application grows and requires more complex data operations, consider:
1. **Service Layer**: Move join logic to a dedicated `MusicService`
2. **Caching**: Cache joined data to reduce Firebase calls
3. **Lazy Loading**: Load artists on-demand instead of all at once
4. **Normalization**: Store artist references and resolve lazily if memory is constrained
