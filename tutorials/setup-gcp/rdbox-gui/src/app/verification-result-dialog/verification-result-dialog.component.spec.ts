import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { VerificationResultDialogComponent } from './verification-result-dialog.component';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { RouterTestingModule } from '@angular/router/testing';


describe('VerificationResultDialogComponent', () => {
  let component: VerificationResultDialogComponent;
  let fixture: ComponentFixture<VerificationResultDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ VerificationResultDialogComponent ],
      imports: [
        MatDialogModule,
        MatButtonModule,
        RouterTestingModule
      ],
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
    fixture = TestBed.createComponent(VerificationResultDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should render title', () => {
    const compiled = fixture.nativeElement;
    expect(compiled.querySelector('h1').textContent).toContain('Verification SUCCESS!!');
  });
});
