# tests/test_app.py
import pytest
from unittest.mock import patch
from app import app # Adjust this import based on your Flask app’s structure gitHub-api.python-project.app.py

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_hello(client):
    with patch("app.render_template") as mock_render_template:
        mock_render_template.return_value = "Rendered template content"  # mock return for the test 
    response = client.get('/')
    assert response.status_code == 200
    #mock_render_template.assert_called_once_with('index.html')
