INSERT INTO users (email, display_name, password_hash, bio, preferences, location_lat, location_lon) VALUES
('Devnull@darkrage.com', 'Devnull', 'hashed_password1', 'Meow.', NULL, 34.0522, -118.2437),
('Orsi@darkrage.com', 'Orsi', 'hashed_password2', '*Squeak*', NULL, 40.7128, -74.0060),
('Rando@darkrage.com', 'John', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Rando1@darkrage.com', 'Sam', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Rando2@darkrage.com', 'Steve', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Eve@darkrage.com', 'Eve', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Josh@darkrage.com', 'Josh', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Gil@darkrage.com', 'Gil', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Dug@darkrage.com', 'Rebecca', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Amanda@darkrage.com', 'Amanda', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Gene@darkrage.com', 'Gene', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Louise@darkrage.com', 'Louise', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Carla@darkrage.com', 'Carla', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Irene@darkrage.com', 'Irene', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060),
('Errol@darkrage.com', 'Errol', 'hashed_password3', 'Wowzer', NULL, 40.7128, -74.0060);


INSERT INTO user_pictures (user_id, picture_url, is_profile_picture) VALUES
(1, '1.jpg', TRUE),
(1, '1.jpg', FALSE),
(2, '2.jpg', TRUE),
(2, '2.jpg', FALSE),
(3, '3.jpg', TRUE),
(3, '3.jpg', FALSE),
(4, '4.jpg', TRUE),
(4, '4.jpg', FALSE),
(5, '5.jpg', TRUE),
(5, '5.jpg', FALSE),
(6, '6.jpg', TRUE),
(6, '6.jpg', FALSE),
(7, '7.jpg', TRUE),
(7, '7.jpg', FALSE),
(8, '8.jpg', TRUE),
(8, '8.jpg', FALSE),
(9, '9.jpg', TRUE),
(9, '9.jpg', FALSE),
(10, '10.jpg', TRUE),
(10, '10.jpg', FALSE),
(11, '11.jpg', TRUE),
(11, '11.jpg', FALSE),
(12, '12.jpg', TRUE),
(12, '12.jpg', FALSE),
(13, '13.jpg', TRUE),
(13, '13.jpg', FALSE),
(14, '14.jpg', TRUE),
(14, '14.jpg', FALSE),
(15, '15.jpg', TRUE),
(15, '15.jpg', FALSE);

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