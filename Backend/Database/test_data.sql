INSERT INTO users (email, display_name, password_hash, bio, preferences, location_lat, location_lon) VALUES
('Devnull@darkrage.com', 'Devnull', 'hashed_password1', 'Meow.', NULL, 34.0522, -118.2437),
('Orsi@darkrage.com', 'Orsi', 'hashed_password2', '*Squeak*', NULL, 40.7128, -74.0060),
('Rando@darkrage.com', 'Rando', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060);

INSERT INTO user_pictures (user_id, picture_url, is_profile_picture) VALUES
(1, 'Devnull1.png', TRUE),
(1, 'Devnull2.png', FALSE),
(2, 'Orsi1.png', TRUE),
(2, 'Orsi2.png', FALSE),
(3, 'Rando.png', TRUE);

INSERT INTO user_interests (user_id, interest) VALUES
(1, 'Sleap'),
(1, 'Eat'),
(1, 'Fifa'),
(2, 'Scratching'),
(2, 'Eating'),
(2, 'Meowing'),
(3, 'Suffer');

INSERT INTO matches (user_id_1, user_id_2, match_score, is_matched) VALUES
(1, 2, 1, TRUE),
(3, 1, 1, FALSE),
(3, 2, 0, FALSE);

INSERT INTO messages (match_id, sender_id, message_text) VALUES
(1, 1, 'Grr'),
(1, 2, 'Grrr'),
(1, 1, 'Grrrr');