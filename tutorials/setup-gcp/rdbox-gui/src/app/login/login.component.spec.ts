import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { LoginComponent } from './login.component';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';


describe('LoginComponent', () => {
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;
  let httpClient: HttpClient;
  let httpTestingController: HttpTestingController;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        MatDialogModule,
        MatButtonModule,
        HttpClientTestingModule
      ],
      declarations: [ LoginComponent ],
      providers: [
        {
          provide: MatDialogRef,
          useValue: {}
        },
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LoginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
    httpClient = TestBed.get(HttpClient);
    httpTestingController = TestBed.get(HttpTestingController);
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it(`should have as title 'rdbox-gui for gcp'`, () => {
    const app = fixture.componentInstance;
    expect(app.title).toEqual('rdbox-gui');
  });

  it('shoud reflect URL by HttpClient.get', () => {
    const testData: Object = {'url': 'https://accounts.google.com/', 'date': '1585223347'};  
    const requests = httpTestingController.match('/api/bootstrap/gcp/login/url');
    expect(requests.length).toEqual(1);
    requests[0].flush(testData);
    httpTestingController.verify();
    fixture.detectChanges();
    const app = fixture.componentInstance;
    const compiled = fixture.nativeElement;
    expect(app.authUrl).toEqual('https://accounts.google.com/');
    expect(compiled.querySelector('.card-container a').getAttribute('href')).toContain('https://accounts.google.com/');
  });
});
